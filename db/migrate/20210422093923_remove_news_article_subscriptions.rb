class RemoveNewsArticleSubscriptions < ActiveRecord::Migration[6.1]
  def change
    drop_table :news_article_subscriptions
  end
end
