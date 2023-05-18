class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.belongs_to :post, null: false, foreign_key: true
      t.string :role
      t.string :content

      t.timestamps
    end
  end
end
