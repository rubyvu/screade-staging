module Tasks
  class NewsArticleTask
    GROUPS_KEYWORDS = {
      'Antiques' => [
        'furniture',
        'antique',
        'baroque',
        'vintage',
        'classic'
      ],
      'Automobiles' => [
        'classic car',
        'car auction',
        'ford',
        'general motors',
        'ferrari',
        'mercedes benz',
        'mercedes-benz',
        'daimler',
        'bmw',
        'toyota',
        'nissan',
        'hyundai',
        'kia',
        'jaguar',
        'land rover',
        'range rover',
        'electric car'
      ],
      'Beauty' => [
        'make-up',
        'make up',
        'plastic surgery',
        'liposuction',
        'botox',
        'hair',
      ],
      'Books' => [
        'best seller',
        'author',
        'book',
      ],
      "Craft's" => [
        'sewing',
        'crocheing',
        'knitting',
        'collage',
      ],
      'Do it Yourself (DIY)' => [
        'home improvement',
        'gardening',
        'woodworking',
        'diy',
      ],
      'Electronics' => [
        'televisions',
        'radio',
        'streaming',
        'ps4',
        'ps5',
        'pc',
        'mac',
        'gadget',
        'ipod',
        'ipad',
        'iphone',
        'apple watch',
        'apple tv',
        'tv',
        'smart watch',
      ],
      'Fashion' => [
        'fashion week',
        'couture',
        'haute couture',
        'vintage clothing',
        'designer fashions',
      ],
      'Finance' => [
        'stocks',
        'bonds',
        'ipo',
        'mutual fund',
        'retirement planning',
        'estate planning',
        'budgeting',
        'financial planning',
        'insurance',
      ],
      'Fitness' => [
        'exercise',
        'gym',
        'nutrition',
        'diet',
        'trainers',
      ],
      'Food' => [
        'restaurant',
        'vegan',
        'vegetarian',
        'super market',
        'organic food',
      ],
      'Gaming' => [
        'video game',
        'twitch',
        'esports',
        'las vegas',
        'gambling',
        'macao',
        'monte carlo',
      ],
      'Opinions' => [
        'editorials',
        'conservatism',
        'liberalism',
      ],
      'Parenting' => [
        'family resources',
        'child raising',
        'adoption',
        'public school',
        'private school',
        'charter school',
        'tutoring',
      ],
      'Pets' => [
        'dog',
        'cat',
        'rabbit',
        'hamster',
        'animal shelter',
      ],
      'Romance' => [
        'dating',
        'relationships',
      ],
      'Religion' => [
        'christianity',
        'catholisism',
        'orthodox',
        'judaism',
        'islam',
        'buddism',
      ],
      'Travel' => [
        'airline',
        'hotel',
        'tourism',
        'flight',
        'airbnb',
        'booking.com',
      ]
    }
    
    def self.detect_language
      NewsArticle.where(detected_language: nil).find_each do |news_article|
        detected_language_code = LanguageDetectionService.detect(news_article.title)
        news_article.update_columns(detected_language: detected_language_code) if detected_language_code
      end
    end
    
    def self.set_youtube_images
      NewsArticle.where(img_url: nil).find_each do |news_article|
        UpdateNewsArticlesYoutubeImagesJob.perform_later(news_article.id)
      end
    end
    
    def self.tag_news_article(news_article)
      tag_source = "#{news_article.title} #{news_article.description}".downcase
      
      Tasks::NewsArticleTask::GROUPS_KEYWORDS.each do |category_title, keywords|
        keywords.each do |keyword|
          if tag_source.include?(keyword)
            category_title = category_title.downcase
            
            news_category = NewsCategory.find_by(title: category_title)
            next unless news_category
            
            next if news_article.news_categories.include?(news_category)
            
            news_article.news_categories << news_category
          end
        end
      end
    end
  end
end
