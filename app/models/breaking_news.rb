class BreakingNews < ApplicationRecord
  
  # Callbacks
  before_save :set_active_news
  after_save :add_notification
  
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
    
    def add_notification
      return unless self.saved_change_to_is_active?(from: false, to: true)
      CreateNewNotificationsJob.perform_later(self.id, self.class.name)
    end
end
