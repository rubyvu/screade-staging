class AddCountersToNewsArticles < ActiveRecord::Migration[6.1]
  def up
    add_column :news_articles, :comments_count, :integer, default: 0, null: false
    add_column :news_articles, :lits_count, :integer, default: 0, null: false
    add_column :news_articles, :views_count, :integer, default: 0, null: false
  end
  
  def down
    remove_column :news_articles, :comments_count
    remove_column :news_articles, :lits_count
    remove_column :news_articles, :views_count
  end
end
