module WordsHelper
  def display_main_image(main_image, size = "500")
    image_tag main_image, class: "word-display"
  end

  def image_link(word)
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
        str += "<div class='col'>"
        str += word.name if show_edit_btn
        str += edit_word_button(word) if show_edit_btn
        str += image_link(word)
        str += "</div>"
      end
      str += "</div>"
    end
    str.html_safe
  end
end
