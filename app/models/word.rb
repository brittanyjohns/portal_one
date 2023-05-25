# == Schema Information
#
# Table name: words
#
#  id          :integer          not null, primary key
#  favorite    :boolean
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :integer          not null
#  group_id    :integer          not null
#
# Indexes
#
#  index_words_on_category_id  (category_id)
#  index_words_on_group_id     (group_id)
#
# Foreign Keys
#
#  category_id  (category_id => categories.id)
#  group_id     (group_id => groups.id)
#
require "espeak"

class Word < ApplicationRecord
  has_many :docs, as: :documentable
  belongs_to :category
  belongs_to :group
  after_save :create_image, if: :no_saved_images

  scope :with_long_name, -> { where("LENGTH(name) > 2") }
  scope :favorites, -> { where(favorite: true) }

  def no_saved_images
    docs === Doc.none
  end

  def options
    { lang: "en-us", pitch: 50, speed: 180, capital: 170 }
  end

  def open_ai_opts
    { prompt: name }
  end

  def main_image
    docs.last&.main_image
  end

  def speak
    # Speaks "YO!"
    lang = options[:lang] || "en-us"
    pitch = options[:pitch] || 50
    speed = options[:speed] || 170
    capital = options[:capital] || 170
    # speech = ESpeak::Speech.new(name, voice: lang)
    speech = ESpeak::Speech.new(name, voice: lang, pitch: pitch, speed: speed, capital: capital)
    speech.speak # invokes espeak
  end

  def create_image_doc(url, img_name)
    new_doc = docs.create(name: img_name, raw_body: url).grab_image(url)
  end

  def create_image
    img_url = OpenAiClient.new(open_ai_opts).create_image
    if img_url
      create_image_doc(img_url, name)
      puts "Successfully created & saved image. "
    else
      puts "**** ERROR **** \nDid not receive valid response.\n"
    end
  end

  def self.request_images(ids)
    Word.with_long_name.find(ids.to_a).each do |word|
      word.save!
      sleep 3
      puts "Saved word #{word.name}"
    end
  end
end
