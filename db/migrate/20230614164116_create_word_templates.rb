class CreateWordTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :word_templates do |t|
      t.belongs_to :word, null: false, foreign_key: true
      t.belongs_to :template, null: false, foreign_key: true

      t.timestamps
    end
  end
end
