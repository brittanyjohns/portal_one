# == Schema Information
#
# Table name: posts
#
#  id                   :integer          not null, primary key
#  body                 :text
#  name                 :string
#  response_type        :integer          default("image")
#  send_request_on_save :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Post < ApplicationRecord
  has_many :docs, as: :documentable
  has_many :messages
  has_rich_text :content
  validates :name, presence: true
  before_save :send_to_ai, if: :send_request_on_save
  after_create :send_to_ai, if: :send_request_on_save
  accepts_nested_attributes_for :docs, allow_destroy: true
  accepts_nested_attributes_for :messages, allow_destroy: true

  scope :images, -> { where(response_type: 0) }
  scope :text, -> { where(response_type: 1) }
  scope :chat, -> { where(response_type: 2) }
  scope :doc, -> { where(response_type: 3) }

  enum response_type: { image: 0, text: 1, chat: 2, doc: 3 }

  def self.response_type_select
    response_types.keys.map { |k| [k.titleize, k] }
  end

  def display_response_type
    response_type || "text"
  end

  def send_to_ai
    puts "Sending response_type: #{response_type}"
    create_image if response_type == "image"
    create_completion if response_type == "text"
    create_chat! if response_type == "chat"
  end

  def image?
    response_type == "image"
  end

  def text?
    response_type == "text"
  end

  def chat?
    response_type == "chat"
  end

  def doc?
    response_type == "doc"
  end

  def last_message
    messages.last&.displayed_content&.body&.to_s || messages.last&.content
  end

  def last_message_raw_string
    messages.last&.content
  end

  def reply(message_content)
    puts "Hey - you're not supposed to be chatting...#{response_type}\nProceeding anyways - You're welcome." unless image?
    messages.create!(role: "user", content: message_content)
    create_chat!
  end

  def format_messages
    if messages.blank?
      [messages.create!(role: "system", content: "You are a funny and sarcastic, but also very helpful, assistant.")]
    else
      messages.map do |msg|
        { role: msg.role, content: msg.content }
      end
    end
  end

  def open_ai_opts
    { prompt: name, messages: format_messages }
  end

  def self.create_image(prompt)
    begin
      img_url = OpenAiClient.new({ prompt: prompt }).create_image
      if img_url
        puts "\n** response from generating AI image **\n #{img_url}"
      else
        puts "**** ERROR **** \nDid not receive valid img_url.\n"
      end
    rescue => e
      puts "\n** ERROR generating AI image **\n #{e.inspect}"
    end
    post = Post.create(name: prompt)

    post.body = img_url
    post.send_request_on_save = false
    rich_text_content = ActionText::RichText.find_or_initialize_by(record_type: "Post", record_id: post.id, name: "content", body: "<img src='#{img_url}' class='ai_img' id='ai_img_#{post.id}'></img>")
    rich_text_content.save!
    post.save!
    create_image_doc(img_url, post.name)
  end

  def create_image_doc(url, img_name)
    new_doc = docs.create(name: img_name, raw_body: url).grab_image(url)
  end

  def create_image
    img_url = OpenAiClient.new(open_ai_opts).create_image
    if img_url
      self.body = img_url
      self.content.body = "<img src='#{img_url}' class='ai_img'></img>"
    else
      puts "**** ERROR **** \nDid not receive valid response.\n"
    end
    self.send_request_on_save = false
    self.save!
    create_image_doc(img_url, name)
  end

  def create_completion
    response = OpenAiClient.new(open_ai_opts).create_completion
    if response
      response_body = "<p class='ai-response'>#{response}</p>"
      self.body = response
      self.content.body = response_body
      self.send_request_on_save = false
      self.save!
      rich_text_content = ActionText::RichText.find_or_initialize_by(record_type: "Post", record_id: post.id, name: "content", body: response_body)
      rich_text_content.save!
    else
      puts "**** ERROR **** \nDid not receive valid response.\n"
    end
    self.send_request_on_save = false
    self
  end

  def create_chat!
    response = OpenAiClient.new(open_ai_opts).create_chat
    puts "Totals response: #{response.inspect}\n\n"
    if response
      role = response[:role]
      content = response[:content]

      self.body = format_messages
      self.content.body = "<p class='ai-response'>#{response}</p>"
      self.send_request_on_save = false
      self.save!
      text = "This is a\nmultiline\nstring."

      new_line_regex = /\n/
      matches = text.scan(new_line_regex)

      puts "Found #{matches.size} new line characters."
      puts matches.inspect

      msg = messages.new(role: role, content: content)
      new_line_regex = /\n/
      replaced_text = content.gsub(new_line_regex, "<br>")

      puts replaced_text
      msg.displayed_content.body = replaced_text

      msg.save!
    else
      puts "**** ERROR **** \nDid not receive valid response.\n"
    end
    self.send_request_on_save = false
    self
  end

  def self.ai_models
    @models = openai_client.models.list
  end
end
