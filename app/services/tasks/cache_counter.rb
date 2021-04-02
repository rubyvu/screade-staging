module Tasks
  class CacheCounter
    def self.run
      # Recount all exists cash counters
      Tasks::CacheCounter.update_lits
      Tasks::CacheCounter.update_comments
      Tasks::CacheCounter.update_views
    end
    
    def self.update_lits
      NewsArticle.joins(:lits).each do |news_article|
        news_article.update_columns(lits_count: news_article.lits.count)
      end
      
      Comment.joins(:lits).each do |comment|
        comment.update_columns(lits_count: comment.lits.count)
      end
    end
    
    def self.update_comments
      NewsArticle.joins(:comments).each do |news_article|
        news_article.update_columns(comments_count: news_article.comments.count)
      end
    end
    
    def self.update_views
      NewsArticle.joins(:views).each do |news_article|
        news_article.update_columns(views_count: news_article.views.count)
      end
    end
  end
end
