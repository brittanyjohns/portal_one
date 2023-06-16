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
class Gallery < ApplicationRecord
  include ImageHelper
  belongs_to :user
  has_many :docs, as: :documentable
  after_save :create_image, :stop_request_on_save!, if: :send_request_on_save

  def open_ai_opts
    { prompt: image_prompt }
  end

  def stop_request_on_save!
    self.send_request_on_save = false
    self.save!
  end

  def toggle_request_on_save!
    self.send_request_on_save = send_request_on_save ? false : true
    self.save!
  end
end
