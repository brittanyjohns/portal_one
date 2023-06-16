module WordsHelper
  # def display_main_image(main_image, size = "500")
  #   image_tag main_image, class: "word-display"
  # end

  # def display_placeholder_image(main_image, size = "500")
  #   image_tag main_image, class: "word-display"
  # end

  # def display_sized_image(main_image, size = "100x100")
  #   image_tag main_image, size: size, class: "sized-display"
  # end

  def word_image_link(word)
    if word.main_image
      link_to(speak_word_path(word), data: { turbo_method: :post }) do
        display_main_image(word.main_image)
      end
    else
      speech_button(word)
    end
  end

  def speech_button(word)
    button_to icon("fa-regular", "comment-dots"), speak_word_path(word), class: "btn", method: :post
  end

  def mark_current_button(doc)
    button_to icon("fa-#{doc.current? ? "solid" : "regular"}", "star"), mark_current_doc_path(doc), class: "btn", method: :post
  end

  def generate_image_word_button(word)
    button_to "#{icon("fa-regular", "image")} CREATE".html_safe, generate_image_word_path(word), class: "btn btn-info", method: :post
  end

  def generate_image_word_variation_button(word)
    button_to icon("fa-solid", "recycle"), generate_image_variation_word_path(word), class: "btn", method: :post
  end

  def edit_word_button(word)
    link_to icon("fa-solid", "pencil"), edit_word_path(word), class: "btn"
  end

  def view_word_button(word)
    link_to icon("fa-solid", "hands-asl-interpreting"), word_path(word), class: "btn"
  end

  def favorite_star(word)
    star_type = word.favorite ? "solid" : "regular"
    icon("fa-#{star_type}", "star")
  end

  def print_grid(words, columns = 4, show_edit_btn = false)
    str = ""
    words.each_slice(columns) do |batch|
      str += "<div class='row'>"
      batch.each do |word|
        show_edit_btn = show_edit_btn || word.no_saved_images
        if show_edit_btn
          str += "<div class='col' data-toggle='tooltip' data-placement='top' title='#{word.name}'>"
          str += word.name
          str += edit_word_button(word)
        else
          str += "<div class='col-img' data-toggle='tooltip' data-placement='top' title='#{word.name}'>"
        end
        str += word_image_link(word)
        str += "</div>"
      end
      str += "</div>"
    end
    str.html_safe
  end

  def print_image_grid(docs, img_size = nil, columns = 4)
    str = ""
    docs.each_slice(columns) do |batch|
      str += "<div class='row'>"
      batch.each do |doc|
        str += "<div class='col-img'>"
        str += display_main_image(doc.main_image, img_size) if doc.main_image
        str += mark_current_button(doc) if @word || @galery
        str += "</div>"
      end
      str += "</div>"
    end
    str.html_safe
  end
end
