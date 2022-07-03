class AddDetectedLanguageToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :detected_language, :string
    add_index :posts, :detected_language
  end
end
