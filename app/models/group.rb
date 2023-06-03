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
  has_many :word_groups
  has_many :words, -> { distinct }, through: :word_groups
  has_many :categories, -> { distinct }, through: :words
  attr_accessor :remaining, :remaining_count

  def unused_words(words_to_filter = nil)
    words_to_filter ||= Word.all
    @remaining = words_to_filter - words
    @remaining_count = @remaining.count
    @remaining
  end
end
