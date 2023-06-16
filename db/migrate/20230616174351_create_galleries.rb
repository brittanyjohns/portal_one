class CreateGalleries < ActiveRecord::Migration[7.1]
  def change
    create_table :galleries do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name
      t.string :state
      t.string :image_prompt
      t.boolean :send_request_on_save

      t.timestamps
    end
  end
end
