# == Schema Information
#
# Table name: words
#
#  id                   :integer          not null, primary key
#  favorite             :boolean
#  name                 :string
#  picture_description  :string
#  send_request_on_save :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  category_id          :integer          not null
#
# Indexes
#
#  index_words_on_category_id  (category_id)
#
# Foreign Keys
#
#  category_id  (category_id => categories.id)
#
require "espeak"

class Word < ApplicationRecord
  has_many :docs, as: :documentable
  has_many :word_groups
  has_many :groups, through: :word_groups
  belongs_to :category
  after_save :create_image, if: :should_create_image
  accepts_nested_attributes_for :docs, allow_destroy: true

  scope :with_long_name, -> { where("LENGTH(name) > 2") }
  scope :favorites, -> { where(favorite: true) }

  CREATE_IMAGES = false

  def no_saved_images
    docs === Doc.none && CREATE_IMAGES
  end

  def should_create_image
    no_saved_images || send_request_on_save
  end

  def default_options
    { lang: "en-us",
      pitch: 50,
      speed: 170,
      capital: 1,
      amplitude: 100,
      quiet: true }
  end

  def open_ai_opts
    prompt_for_image = picture_description || name
    puts "prompt_for_image: #{prompt_for_image}"
    { prompt: prompt_for_image }
  end

  def main_image
    docs.last&.main_image
  end

  def speak
    # Speaks "YO!"
    lang = default_options[:lang]
    pitch = default_options[:pitch]
    speed = default_options[:speed]
    capital = default_options[:capital]
    amplitude = default_options[:amplitude]
    quiet = default_options[:quiet]
    # speech = ESpeak::Speech.new(name, voice: lang)
    speech = ESpeak::Speech.new(name, voice: lang, pitch: pitch, speed: speed, capital: capital, amplitude: amplitude, quiet: quiet)
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
