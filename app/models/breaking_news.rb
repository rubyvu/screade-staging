class BreakingNews < ApplicationRecord
  
  # Callbacks
  before_save :set_active_news
  
  # Fields validations
  validates :title, presence: true
  
  private
    def set_active_news
      # Activate only one breaking news for country
      return unless self.is_active_changed?(from: false, to: true)
      
      if self.new_record?
        breaking_news = BreakingNews.where(is_active: true)
      else
        breaking_news = BreakingNews.where(is_active: true).where.not(id: self.id)
      end
      
      breaking_news.update_all(is_active: false)
    end
end
