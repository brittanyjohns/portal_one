require "openai"

class OpenAiClient
  DEFAULT_MODEL = "text-davinci-001"
  TURBO_MODEL = "gpt-3.5-turbo"

  def initialize(opts)
    @messages = opts["messages"] || opts[:messages] || []
    @prompt = opts["prompt"] || opts[:prompt] || "backup"
  end

  def self.openai_client
    @openai_client ||= OpenAI::Client.new(access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"))
  end

  def openai_client
    @openai_client ||= OpenAI::Client.new(access_token: ENV.fetch("OPENAI_ACCESS_TOKEN"))
  end

  def create_image
    puts "prompt = #{@prompt}"

    response = openai_client.images.generate(parameters: { prompt: @prompt, size: "512x512" })
    puts "response: #{response}"
    if response
      img_url = response.dig("data", 0, "url")
    else
      puts "**** ERROR **** \nDid not receive valid response.\n#{response}"
    end
    img_url
  end

  def create_completion
    response = openai_client.completions(parameters: { model: DEFAULT_MODEL, prompt: @prompt })
    if response
      choices = response["choices"].map { |c| "<p class='ai-response'>#{c["text"]}</p>" }.join("\n")
      puts "CHOICES: #{choices}"
      response_body = choices[0]
    else
      puts "**** ERROR **** \nDid not receive valid response.\n"
    end
    response_body
  end

  def create_chat
    opts = {
      model: TURBO_MODEL, # Required.
      messages: @messages, # Required.
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
      @role = response.dig("choices", 0, "message", "role")
      @content = response.dig("choices", 0, "message", "content")
    else
      puts "**** ERROR **** \nDid not receive valid response.\n"
    end
    { role: @role, content: @content }
  end

  def self.ai_models
    @models = openai_client.models.list
  end
end

# opts = { prompt: "a purple cow" }
# client = OpenAiClient.new(opts)
# img_url = client.create_image
# puts "img_url: #{img_url}"
