# == Schema Information
#
# Table name: posts
#
#  id                   :integer          not null, primary key
#  body                 :text
#  name                 :string
#  response_type        :integer          default("image")
#  send_request_on_save :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require "test_helper"

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
