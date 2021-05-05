module Tasks
  class NewsArticleTask
    
    def self.detect_language
      NewsArticle.where(detected_language: nil).find_each do |news_article|
        detected_language = CLD.detect_language("#{news_article.title} #{news_article.description}")
        detected_language_code = detected_language[:code]&.upcase
        if detected_language_code.present?
          detected_language_code = 'ZH' if detected_language_code == 'ZH-TW'
          news_article.update_columns(detected_language: detected_language_code)
        end
      end
    end
  end
end
