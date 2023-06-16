module ApplicationHelper
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

  def display_main_image(main_image, size = "500")
    image_tag main_image, class: "word-display"
  end

  def display_placeholder_image(main_image, size = "500")
    image_tag main_image, class: "word-display"
  end

  def display_sized_image(main_image, size = "100x100")
    image_tag main_image, size: size, class: "sized-display"
  end

  def image_link(item)
    if item.main_image
      display_main_image(item.main_image)
    end
  end
end
