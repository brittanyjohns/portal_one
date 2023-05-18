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
  accepts_nested_attributes_for :docs, allow_destroy: true
  accepts_nested_attributes_for :messages, allow_destroy: true

  scope :images, -> { where(response_type: 0) }
  scope :text, -> { where(response_type: 1) }

  enum response_type: { image: 0, text: 1 }
  DEFAULT_MODEL = "text-davinci-001"

  def self.response_type_select
    response_types.keys.map { |k| [k.titleize, k] }
  end

  def send_to_ai
    puts "Sending response_type: #{response_type}"
    create_image if response_type == "image"
    create_completion if response_type == "text"
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
      response = openai_client.images.generate(parameters: { prompt: prompt, size: "1024x1024" })
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

  def create_image
    response = openai_client.images.generate(parameters: { prompt: name, size: "1024x1024" })
    if response
      img_url = response.dig("data", 0, "url")
      self.body = response
      self.content.body = "<img src='#{img_url}' class='ai_img'></img>"
    else
      puts "**** ERROR **** \nDid not receive valid response.\n"
    end
    self.send_request_on_save = false
  end

  def create_completion
    response = openai_client.completions(parameters: { model: DEFAULT_MODEL, prompt: name })
    if response
      choices = response["choices"].map { |c| "<p class='ai-response'>#{c["text"]}</p>" }.join("\n")
      puts "CHOICES: #{choices}"
      self.body = response
      self.content.body = "<p class='ai-response'>#{choices[0]}</p>"
    else
      puts "**** ERROR **** \nDid not receive valid response.\n"
    end
    self.send_request_on_save = false
    self
  end

  def create_chat
    response = openai_client.chat(
      parameters: {
        model: "gpt-3.5-turbo", # Required.
        messages: [{ role: "user", content: "Hello!" }], # Required.
        temperature: 0.7,
      },
    )
    puts response.dig("choices", 0, "message", "content")
    # => "Hello! How may I assist you today?"
    if response
      choices = response["choices"].map { |c| "<p class='ai-response'>#{c["text"]}</p>" }.join("\n")
      puts "CHOICES: #{choices}"
      self.body = response
      self.content.body = "<p class='ai-response'>#{choices[0]}</p>"
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
