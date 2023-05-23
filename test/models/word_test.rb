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
require "test_helper"

class WordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
