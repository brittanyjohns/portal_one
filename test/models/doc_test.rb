# == Schema Information
#
# Table name: docs
#
#  id                :integer          not null, primary key
#  body              :text
#  current           :boolean
#  doc_type          :string
#  documentable_type :string           not null
#  name              :string
#  prompt_used       :string
#  raw_body          :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  documentable_id   :integer          not null
#
# Indexes
#
#  index_doc_on_documentable  (documentable_type,documentable_id)
#
require "test_helper"

class DocTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
