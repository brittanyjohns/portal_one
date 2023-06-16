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
  include ImageHelper
  include SpeechHelper
  default_scope { includes(:docs) }
  has_many :docs, as: :documentable
  has_many :word_groups
  has_many :groups, through: :word_groups
  belongs_to :category
  has_many :word_templates
  has_many :templates, through: :word_templates
  after_save :create_image, if: :should_create_image
  after_save :stop_request_on_save!, if: :send_request_on_save
  accepts_nested_attributes_for :docs, allow_destroy: true

  scope :with_long_name, -> { where("LENGTH(name) > 2") }
  scope :favorites, -> { where(favorite: true) }

  CREATE_IMAGES = true

  def self.not_in_group(group_id)
    self.includes(:word_groups).where(word_groups: { group_id: group_id })
  end

  def to_s
    name
  end

  def no_saved_images
    docs === Doc.none && CREATE_IMAGES
  end

  def should_create_image
    no_saved_images || send_request_on_save
  end

  def stop_request_on_save!
    self.send_request_on_save = false
    self.save!
  end

  def image_name_to_send
    !picture_description.blank? ? picture_description : name
  end

  def open_ai_opts
    { prompt: image_name_to_send }
  end

  def self.request_images(ids)
    Word.with_long_name.find(ids.to_a).each do |word|
      word.save!
      sleep 3
      puts "Saved word #{word.name}"
    end
  end
end
