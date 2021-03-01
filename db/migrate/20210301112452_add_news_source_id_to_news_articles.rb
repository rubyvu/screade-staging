class AddNewsSourceIdToNewsArticles < ActiveRecord::Migration[6.1]
  def up
    add_column :news_articles, :news_source_id, :integer
  end
  
  def down
    remove_column :news_articles, :news_source_id
  end
end
