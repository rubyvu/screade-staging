class CreateJoinTableNewsArticlesTopics < ActiveRecord::Migration[6.1]
  def change
    create_join_table :news_articles, :topics do |t|
      t.index [:news_article_id, :topic_id]
    end
  end
end
