class CreateWordGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :word_groups do |t|
      t.string :name
      t.belongs_to :word, null: false, foreign_key: true
      t.belongs_to :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
