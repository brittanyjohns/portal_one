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
require "test_helper"

class WordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
