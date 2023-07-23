# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Category < ApplicationRecord
  has_many :words

  def print_words
    words.map(&:name)
  end

  def self.uncategorized_id
    7
  end
end
