class IndexNewsArticlesOnLitsCount < ActiveRecord::Migration[6.1]
  def change
    add_index :news_articles, :lits_count
  end
end
