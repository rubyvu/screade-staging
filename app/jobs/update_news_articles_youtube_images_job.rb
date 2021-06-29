class UpdateNewsArticlesYoutubeImagesJob < ApplicationJob
  
  def run(news_article_id)
    news_article = NewsArticle.find_by(id: news_article_id)
    return if news_article.blank?
    
    img_url = Tasks::NewsApi.get_youtube_img(news_article.url)
    return if img_url.blank?
    
    news_article.update_columns(img_url: img_url)
  end
end
