class CreateTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :templates do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name
      t.string :template_type

      t.timestamps
    end
  end
end
