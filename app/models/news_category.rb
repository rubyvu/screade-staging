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
  # User Subscripted for NewsCategory
  has_many :user_topic_subscriptions, as: :source, dependent: :destroy
  has_many :subscripted_users, through: :user_topic_subscriptions, source: :user
  # News Article Subscriptions
  has_many :news_article_subscriptions, as: :source, dependent: :destroy
  has_many :subscripted_news_articles, through: :news_article_subscriptions, source: :news_article
  
  # Fields validations
  validates :title, uniqueness: true, presence: true
  
  # Normalization
  def title=(value)
    super(value&.downcase&.strip)
  end
  
  # Get All Approved Topics for NewsCategory
  def approved_nested_topics_ids
    get_children_topics_ids(self.topics.ids, 1)
  end
  
  private
    def skip_default_categories
      errors.add(:base, 'The default category cannot be destroyed') if NewsCategory::DEFAULT_CATEGORIES.include?(self.title)
    end
    
    def get_children_topics_ids(topic_ids, nesting_position)
      ids = Topic.where(parent_id: topic_ids, is_approved: true, nesting_position: nesting_position).ids
      
      return ids+topic_ids if nesting_position == 2
      get_children_topics_ids(ids+topic_ids, nesting_position+1)
    end
end
