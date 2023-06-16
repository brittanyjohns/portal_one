# == Schema Information
#
# Table name: templates
#
#  id            :integer          not null, primary key
#  name          :string
#  template_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :integer          not null
#
# Indexes
#
#  index_templates_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Template < ApplicationRecord
  belongs_to :user
end
