module ApplicationHelper
  def print_image_grid(docs, columns = 3)
    str = "<div class=''>"

    docs.each_slice(columns) do |batch|
      str += "<div class='row'>"
      batch.each do |doc|
        str += "<div id='doc_#{doc.id}' class='col-img'>"
        str += generate_variation_button(doc)
        str += mark_current_button(doc)
        str += image_link(doc, "word-display") if doc.main_image
        str += "</div>"
      end
      str += "</div>"
    end
    str += "</div>"
    str.html_safe
  end

  def doc_grid_item(doc)
    str = ""
    str += "<div id='doc_#{doc.id}' class='col-sm-6 col-md-4'>"
    str += mark_current_button(doc)
    str += display_main_image(doc.main_image, "sub-image") if doc.main_image
    str += "</div>"
    str.html_safe
  end

  def star_rating(average_score)
    rounded_score = average_score.to_i
    remainder = average_score.modulo(1)
    content = ""
    checked = "<span class='fa fa-star checked'></span>"
    unchecked = "<span class='fa-regular fa-star'></span>"
    half = "<span class='fa-regular fa-star-half-stroke'></span>"

    rating = checked * rounded_score
    if remainder >= 0.5
      empty_stars = 5 - (rounded_score + 1)
      empty = unchecked * empty_stars
      content = rating + empty
      content += half
    else
      empty_stars = 5 - rounded_score
      empty = unchecked * empty_stars
      content = rating + empty
    end

    content.html_safe
  end

  def display_main_image(main_image, class_to_add = nil)
    image_tag main_image, class: "#{class_to_add}"
  end

  def display_placeholder_image(main_image)
    image_tag main_image, class: "word-displayx"
  end

  def display_sized_image(main_image, size = "100x100")
    image_tag main_image, size: size, class: "sized-display"
  end

  def image_link(item, class_to_add = nil)
    if item.main_image
      if @gallery
        link_to item do
          display_main_image(item.main_image, class_to_add)
        end
      else
        link_to item.documentable do
          display_main_image(item.main_image, class_to_add)
        end
      end
    end
  end

  def mark_current_button(doc)
    button_to icon("fa-#{doc.current? ? "solid" : "regular"}", "star"), mark_current_doc_path(doc), class: "btn current-btn", method: :post
  end

  def generate_variation_button(doc)
    button_to icon("fa-solid", "recycle"), create_variation_doc_path(doc), class: "btn doc-var-btn", method: :post
  end
end
