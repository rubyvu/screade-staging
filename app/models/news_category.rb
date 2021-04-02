class NewsCategory < ApplicationRecord
  # Constants
  DEFAULT_CATEGORIES = %w(business entertainment general health science sports technology)
  
  # Upploaders
  mount_uploader :image, GroupIconUploader
  
  # Callback
  before_destroy :skip_default_categories, prepend: true do
    throw(:abort) if errors.present?
  end
  
  # Associations
  has_and_belongs_to_many :news_articles
  has_many :topics, as: :parent, dependent: :destroy
  # News Subscriptions
  has_many :news_subscriptions, as: :source, dependent: :destroy
  has_many :news_subscriptions_users, through: :news_subscriptions, source: :user
  
  # Fields validations
  validates :title, uniqueness: true, presence: true
  
  # Normalization
  def title=(value)
    super(value&.downcase&.strip)
  end
  
  private
    def skip_default_categories
      errors.add(:base, 'The default category cannot be destroyed') if NewsCategory::DEFAULT_CATEGORIES.include?(self.title)
    end
end
