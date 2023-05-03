class CreateDocs < ActiveRecord::Migration[7.1]
  def change
    create_table :docs do |t|
      t.string :name
      t.string :doc_type
      t.text :body
      t.text :raw_body
      t.string :documentable_type, null: false
      t.integer :documentable_id, null: false

      t.timestamps
      t.index [:documentable_type, :documentable_id], name: "index_doc_on_documentable"
    end
  end
end
