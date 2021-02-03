module Tasks
  class NewsApi
    
    @news = News.new(ENV['NEWS_API_KEY'])
    
    def self.get_articles(country_title)
      country = Country.find_by(title: country)
      return unless country
      
      NewsCategory.all.each do |category|
        all_category_articles = get_all_category_articles(country.title, category.title)
        
        # Create Que job to save Article
        # JOB.create_articles(country.title, category.title, all_category_articles) if all_category_articles.count > 0
      end
    end
    
    def self.get_all_category_articles(country, category, page=1, all_articles=[])
      begin
        news_array = @news.get_top_headlines(country: country, category: category, page: page, pageSize: '100')
      rescue
        puts "----- News API error while getting top headlines articles"
        news_array = []
      end
      all_articles + news_array
      
      return all_articles if news_array.count < 100
      
      get_category_articles(country, category, page+1, all_articles)
    end
    
    def self.create_articles(country_title, category_title, all_category_articles)
      country = Country.find_by(title: country_title)
      return unless country
      
      category = NewsCategory.find_by(title: category_title)
      return unless category
      
      all_category_articles.each do |article|
        # Since all_category_articles stored data in publishedAt order that started
        # from the newest, we can interrupt an iterator when finding a match in DB
        return if NewsArticle.exists?(url: article.url)
        
        article_attr = {
          country: country,
          category: category,
          published_at: article.published_at,
          author: article.author,
          title: article.title,
          description: article.description,
          url: article.url,
          img_url: article.img_url
        }
        
        new_article = NewsArticle.new(article_attr)
        puts new_article.errors.full_messages unless new_article.save
      end
    end
    
  end
end
