# == Schema Information
#
# Table name: galleries
#
#  id                   :integer          not null, primary key
#  image_prompt         :string
#  name                 :string
#  send_request_on_save :boolean
#  state                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :integer          not null
#
# Indexes
#
#  index_galleries_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
require "test_helper"

class GalleryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
