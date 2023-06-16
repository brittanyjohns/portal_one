# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
class Group < ApplicationRecord
  # belongs_to :user
  default_scope { includes(:word_groups) }

  has_many :word_groups
  has_many :words, -> { distinct }, through: :word_groups
  has_many :categories, -> { distinct }, through: :words
  accepts_nested_attributes_for :words, reject_if: blank?, allow_destroy: false
  accepts_nested_attributes_for :word_groups, allow_destroy: true

  def remaining_words(words_to_filter = nil)
    words_to_filter ||= Word.all
    words_to_filter.where.not(id: word_ids)
  end
end
