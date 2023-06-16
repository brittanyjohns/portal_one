# == Schema Information
#
# Table name: word_templates
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  template_id :integer          not null
#  word_id     :integer          not null
#
# Indexes
#
#  index_word_templates_on_template_id  (template_id)
#  index_word_templates_on_word_id      (word_id)
#
# Foreign Keys
#
#  template_id  (template_id => templates.id)
#  word_id      (word_id => words.id)
#
require "test_helper"

class WordTemplateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
