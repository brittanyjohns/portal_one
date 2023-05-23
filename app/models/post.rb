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
  DEFAULT_MODEL = "text-davinci-001"
  TURBO_MODEL = "gpt-3.5-turbo"

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
    create_chat if response_type == "chat"
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

  def format_messages
    messages.map do |msg|
      { role: msg.role, content: msg.content }
    end
  end

  def self.openai_client
    @openai_client ||= OpenAI::Client.new(access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"))
  end

  def openai_client
    @openai_client ||= OpenAI::Client.new(access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"))
  end

  def self.create_image(prompt)
    post = Post.create(name: prompt)
    begin
      response = openai_client.images.generate(parameters: { prompt: prompt, size: "512x512" })
      img_url = response.dig("data", 0, "url")
      puts "\n** response from generating AI image **\n #{response.inspect}"
    rescue => e
      puts "\n** ERROR generating AI image **\n #{e.inspect}"
    end

    post.body = response
    post.send_request_on_save = false
    rich_text_content = ActionText::RichText.find_or_initialize_by(record_type: "Post", record_id: post.id, name: "content", body: "<img src='#{img_url}' class='ai_img' id='ai_img_#{post.id}'></img>")
    rich_text_content.save!
    post.save!
  end

  def create_image_doc(url, img_name)
    new_doc = docs.create(name: img_name, raw_body: url).grab_image(url, true)
  end

  def create_image
    response = openai_client.images.generate(parameters: { prompt: name, size: "512x512" })
    if response
      img_url = response.dig("data", 0, "url")
      self.body = response
      self.content.body = "<img src='#{img_url}' class='ai_img'></img>"
    else
      puts "**** ERROR **** \nDid not receive valid response.\n"
    end
    self.send_request_on_save = false
    self.save!
    create_image_doc(img_url, name)
  end

  def create_completion
    response = openai_client.completions(parameters: { model: DEFAULT_MODEL, prompt: name })
    if response
      choices = response["choices"].map { |c| "<p class='ai-response'>#{c["text"]}</p>" }.join("\n")
      puts "CHOICES: #{choices}"
      response_body = "<p class='ai-response'>#{choices[0]}</p>"
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

  def create_chat
    opts = {
      model: TURBO_MODEL, # Required.
      messages: format_messages, # Required.
      temperature: 0.7,
    }
    puts "opts: #{opts.inspect}"
    response = openai_client.chat(
      parameters: opts,
    )
    puts "Totals response: #{response.inspect}\n\n"
    puts response.dig("choices", 0, "message", "content")
    # => "Hello! How may I assist you today?"
    if response
      role = response.dig("choices", 0, "message", "role")
      content = response.dig("choices", 0, "message", "content")

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
