class AddDetectedLanguageToComments < ActiveRecord::Migration[6.1]
  def change
    add_column :comments, :detected_language, :string
    add_index :comments, :detected_language
  end
end
