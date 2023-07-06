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
  include ImageHelper
  has_many :docs, as: :documentable
  has_many :messages
  has_rich_text :content
  validates :name, presence: true
  # before_save :send_to_ai, if: :send_request_on_save
  # after_create :send_to_ai, if: :send_request_on_save
  after_save :send_to_ai, :stop_request_on_save!, if: :send_request_on_save
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

  def stop_request_on_save!
    self.send_request_on_save = false
    self.save!
  end

  def toggle_request_on_save!
    self.send_request_on_save = send_request_on_save ? false : true
    self.save!
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

  def create_completion
    response = OpenAiClient.new(open_ai_opts).create_completion
    if response
      response_body = "<p class='ai-response'>#{response}</p>"
      self.body = response
      self.content.body = response_body
      self.send_request_on_save = false
      self.save!
      rich_text_content = ActionText::RichText.find_or_initialize_by(record_type: "Post", record_id: id, name: "content", body: response_body)
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
      replaced_text = content.gsub(new_line_regex, "<br>") if content

      puts replaced_text
      msg.displayed_content.body = replaced_text

      msg.save!
    else
      puts "**** ERROR **** \nDid not receive valid response.\n"
    end
    self.send_request_on_save = false
    self
  end
end
