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
end
