class CreateNewsArticleSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :news_article_subscriptions do |t|
      t.integer :news_article_id, null: false
      t.integer :source_id, null: false
      t.string :source_type, null: false
      t.timestamps
      t.index [:news_article_id, :source_id, :source_type], unique: true, name: 'index_news_article_subscriptions_on_news_article_and_source'
    end
  end
end
