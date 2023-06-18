module GalleriesHelper
  def generate_image_gallery_button(gallery)
    button_to "#{icon("fa-regular", "image")} CREATE".html_safe, generate_image_gallery_path(gallery), class: "btn btn-primary btn-group", method: :post
  end

  def generate_image_gallery_variation_button(gallery)
    button_to "#{icon("fa-solid", "recycle")} GENERATE VARIATION".html_safe, generate_image_variation_gallery_path(gallery), class: "btn overlay variation-btn", method: :post
  end
end
