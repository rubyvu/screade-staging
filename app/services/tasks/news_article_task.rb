module Tasks
  class NewsArticleTask
    
    def self.detect_language
      NewsArticle.find_each do |news_article|
        detected_language = CLD.detect_language("#{news_article.title}")
        detected_language_code = detected_language[:code]&.upcase
        if detected_language_code.present?
          case detected_language_code
          when 'ZH-TW'
            detected_language_code = 'ZH'
          when 'UK'
            detected_language_code = 'UA'
          end
          
          news_article.update_columns(detected_language: detected_language_code)
        end
      end
    end
  end
end
