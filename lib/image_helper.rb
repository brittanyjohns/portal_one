module ImageHelper
  def name_to_send
    open_ai_opts[:prompt] || name
  end

  def main_doc
    docs.current || docs.last
  end

  def main_image
    main_doc&.main_image
  end

  def create_image_doc(url, img_name)
    new_doc = docs.create(name: img_name, raw_body: url, current: true).grab_image(url)
  end

  def create_image
    img_url = OpenAiClient.new(open_ai_opts).create_image
    if img_url
      create_image_doc(img_url, name_to_send)
    else
      puts "**** ERROR **** \nDid not receive valid response.\n"
    end
  end

  def create_image_variation(img_url = nil)
    img_url ||= main_doc.main_image_on_disk
    img_variation_url = OpenAiClient.new(open_ai_opts).create_image_variation(img_url)
    if img_variation_url
      create_image_doc(img_variation_url, name_to_send)
    else
      puts "**** ERROR **** \nDid not receive valid response.\n"
    end
  end
end
