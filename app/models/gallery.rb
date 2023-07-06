# == Schema Information
#
# Table name: galleries
#
#  id                   :integer          not null, primary key
#  image_prompt         :string
#  name                 :string
#  send_request_on_save :boolean
#  state                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :integer          not null
#
# Indexes
#
#  index_galleries_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Gallery < ApplicationRecord
  include ImageHelper
  belongs_to :user
  has_many :docs, as: :documentable
  after_save :create_image, :stop_request_on_save!, if: :send_request_on_save

  def open_ai_opts
    { prompt: image_prompt }
  end

  def random_prompt
    random_prompts.sample
  end

  def stop_request_on_save!
    self.send_request_on_save = false
    self.save!
  end

  def toggle_request_on_save!
    self.send_request_on_save = send_request_on_save ? false : true
    self.save!
  end

  def current_image_prompt
    docs.current&.name
  end

  def image_types
    ["Sigma 24mm f/8",
     "Pixel Art",
     "Anime",
     "Digital art",
     "Photography",
     "Sculpture",
     "Printmaking",
     "Mixed media",
     "Graphic design",
     "Ceramic pottery",
     "Glassblowing",
     "Stained glass",
     "Metal sculpture",
     "Street art",
     "Graffiti art",
     "Calligraphy",
     "Pencil drawing",
     "Ink illustration",
     "Cartoon art",
     "Comic book art",
     "Mosaic art",
     "Textile art",
     "Embroidery",
     "Jewelry making",
     "Installation art",
     "Performance art",
     "Video art",
     "Animation",
     "Concept art",
     "Abstract art",
     "Realism art",
     "Impressionism",
     "Surrealism",
     "Pop art",
     "Minimalism",
     "Cubism",
     "Renaissance art",
     "Modern art",
     "Contemporary art"]
  end

  def remove_extras_from_prompt(prompt_text)
    return "" unless prompt_text
    puts "", "prompt_text: #{prompt_text}"
    image_types.each do |item|
      art_type = item.downcase
      normalized_prompt_text = prompt_text&.downcase
      prompt_text = normalized_prompt_text&.gsub(art_type, "")&.strip
    end
    puts "scrubbed_text: #{prompt_text}"
    prompt_text
  end

  def includes_extra_prompt?
    image_types.each do |type|
      return true if image_prompt.includes?(type)
      false
    end
  end

  def clear_extra_prompt(type_to_remove)
    self.image_prompt = image + prompt.gsub()
    image_types.each do |type|
      return true if image_prompt.includes?(type)
      false
    end
  end
end
