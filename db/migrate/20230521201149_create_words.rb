class CreateWords < ActiveRecord::Migration[7.1]
  def change
    create_table :words do |t|
      t.string :name
      t.belongs_to :category, null: false, foreign_key: true
      t.boolean :favorite
      t.belongs_to :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
