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
  belongs_to :category
  belongs_to :group

  def options
    { lang: "en-us", pitch: 50, speed: 180, capital: 170 }
  end

  def speak
    # Speaks "YO!"
    lang = options[:lang]
    pitch = options[:pitch]
    speed = options[:speed]
    capital = options[:capital]
    speech = ESpeak::Speech.new(name, voice: lang)
    # speech = ESpeak::Speech.new(name, voice: lang, pitch: pitch, speed: speed, capital: capital)
    speech.speak # invokes espeak
  end
end
