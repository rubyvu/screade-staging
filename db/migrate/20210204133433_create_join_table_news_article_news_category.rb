class CreateJoinTableNewsArticleNewsCategory < ActiveRecord::Migration[6.1]
  def change
    create_join_table :news_articles, :news_categories do |t|
      t.index [:news_article_id, :news_category_id], name: 'index_news_articles_categories_on_ids'
    end
  end
end
