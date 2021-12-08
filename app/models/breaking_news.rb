class BreakingNews < ApplicationRecord
  
  # Callbacks
  after_save :add_notification
  
  # Association
  belongs_to :post, optional: true
  
  def self.get_breaking_news
    breaking_news = BreakingNews.first
    breaking_news = BreakingNews.create if breaking_news.nil?
    breaking_news
  end
  
  private
    def add_notification
      return unless self.post && self.saved_change_to_post_id?
      CreateNewNotificationJob.perform_later(self.id, self.class.name)
    end
end
