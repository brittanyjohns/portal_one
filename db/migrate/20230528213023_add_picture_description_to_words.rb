class AddPictureDescriptionToWords < ActiveRecord::Migration[7.1]
  def change
    add_column :words, :send_request_on_save, :boolean, default: false
    add_column :words, :picture_description, :string
  end
end
