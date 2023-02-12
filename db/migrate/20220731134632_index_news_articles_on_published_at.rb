class IndexNewsArticlesOnPublishedAt < ActiveRecord::Migration[6.1]
  def change
    add_index :news_articles, :published_at
  end
end
