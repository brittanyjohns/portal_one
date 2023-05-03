class AddSendFlagToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :send_request_on_save, :boolean, default: false
    add_column :posts, :response_type, :integer, default: 0
  end
end
