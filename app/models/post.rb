class Post < ApplicationRecord
  has_many :docs, as: :documentable
  has_rich_text :content
  before_save :send_to_ai, if: :send_request_on_save?

  enum response_type: { image: 0, text: 1 }

  def self.response_type_select
    response_types.keys.map { |k| [k.titleize, k] }
  end

  def send_to_ai
    create_image if response_type == 0
  end

  def self.openai_client
    @openai_client ||= OpenAI::Client.new(access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"))
  end

  def openai_client
    @openai_client ||= OpenAI::Client.new(access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"))
  end

  def self.create_image(prompt, post_id = nil)
    post = Post.find(post_id)
    post.name = prompt
    unless post
      post = Post.find_or_initialize_by(name: prompt)
    end
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
end
