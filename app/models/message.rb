# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  content    :string
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer          not null
#
# Indexes
#
#  index_messages_on_post_id  (post_id)
#
# Foreign Keys
#
#  post_id  (post_id => posts.id)
#
class Message < ApplicationRecord
  belongs_to :post
  has_rich_text :displayed_content
  validates :role, presence: true
  before_save :save_rich_content, if: :missing_content

  def save_rich_content
    if content
      puts "setting display text"
      new_line_regex = /\n/
      replaced_text = content.gsub(new_line_regex, "<br>")

      puts replaced_text
      self.displayed_content.body = replaced_text
    end
  end

  def missing_content
    displayed_content.nil? || displayed_content.body.blank?
    true
  end
end
