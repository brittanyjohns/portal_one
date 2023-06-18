class AddPromptToDocs < ActiveRecord::Migration[7.1]
  def change
    add_column :docs, :prompt_used, :string
    add_column :docs, :current, :boolean
  end
end
