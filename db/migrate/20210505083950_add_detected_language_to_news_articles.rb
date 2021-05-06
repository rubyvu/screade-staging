class AddDetectedLanguageToNewsArticles < ActiveRecord::Migration[6.1]
  def up
    add_column :news_articles, :detected_language, :string
    add_index :news_articles, :detected_language
  end
  
  def down
    remove_column :news_articles, :detected_language
  end
end
