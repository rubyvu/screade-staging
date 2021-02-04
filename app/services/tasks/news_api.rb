module Tasks
  class NewsApi
    
    @news = News.new(ENV['NEWS_API_KEY'])
    
    def self.get_articles(country_code)
      country = Country.find_by(code: country_code)
      return unless country
      
      NewsCategory.all.each do |category|
        # Create Que job to save Article
        CreateNewsArticlesJob.perform_later(country.code, category.title)
      end
    end
    
    def self.create_articles(country_code, category_title)
      country = Country.find_by(code: country_code)
      return unless country
      
      category = NewsCategory.find_by(title: category_title)
      return unless category
      
      all_category_articles = get_all_category_articles(country.code, category.title)
      all_category_articles.each do |article|
        article_attr = {
          country: country,
          published_at: article.publishedAt,
          author: article.author,
          title: article.title,
          description: article.description,
          url: article.url,
          img_url: article.urlToImage
        }
        
        article = NewsArticle.find_by(url: article.url)
        unless article
          article = NewsArticle.new(article_attr)
          unless article.save
            puts "!!!!!!! ERROR: #{article.errors.full_messages}"
            next
          end
        end
        
        article.news_categories << category if article && article.news_categories.pluck(:title).exclude?(category.title)
      end
    end
    
    private
      def self.get_all_category_articles(country_code, category, page=1, all_articles=[])
        puts "=============================="
        puts "Country: #{country_code}"
        puts "Category: #{category}"
        puts "Page: #{page}"
        
        begin
          # Return all headline articles published in 24 hour
          news_array = @news.get_top_headlines(country: country_code, category: category, page: page, pageSize: '100')
        rescue
          puts "!!!!!!! ERROR: Cannot get Top Headlines for #{country_code} country, #{category} category"
          news_array = []
        end
        
        all_articles += news_array
        return all_articles if news_array.count < 100
        
        get_all_category_articles(country_code, category, page+1, all_articles)
      end
  end
end
