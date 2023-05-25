module WordsHelper
  def display_main_image(main_image, size = "200")
    image_tag main_image, size: size
  end

  def image_link(word)
    if word.main_image
      link_to(speak_word_path(word), data: { turbo_method: :post }) do
        display_main_image(word.main_image)
      end
    else
      puts "Nope"
      link_to word.name, speak_word_path(word), data: { turbo_method: :post }
    end
  end

  def speech_button(word)
    button_to icon("fa-regular", "comment-dots"), speak_word_path(word), class: "btn", method: :post
  end

  def view_word_button(word)
    link_to icon("fa-solid", "hands-asl-interpreting"), word_path(word), class: "btn"
  end

  def favorite_star(word)
    star_type = word.favorite ? "solid" : "regular"
    icon("fa-#{star_type}", "star")
  end

  def print_grid(words, columns = 4)
    str = ""
    words.each_slice(columns) do |batch|
      str += "<div class='row'>"
      batch.each do |word|
        str += "<div class='col'>#{image_link(word)}#{view_word_button(word)}</div>"
      end
      str += "</div>"
    end
    str.html_safe
  end
end
