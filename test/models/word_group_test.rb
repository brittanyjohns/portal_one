# == Schema Information
#
# Table name: word_groups
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer          not null
#  word_id    :integer          not null
#
# Indexes
#
#  index_word_groups_on_group_id  (group_id)
#  index_word_groups_on_word_id   (word_id)
#
# Foreign Keys
#
#  group_id  (group_id => groups.id)
#  word_id   (word_id => words.id)
#
require "test_helper"

class WordGroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
