class TagNewsArticlesJob < ApplicationJob
  
  def run(news_article_id)
    news_article = NewsArticle.find(news_article_id)
    return unless news_article
    
    Tasks::NewsArticleTask.tag_news_article(news_article)
  end
end
