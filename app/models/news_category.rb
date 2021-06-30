class NewsCategory < ApplicationRecord
  # Search
  searchkick text_middle: [:title]
  
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
  has_many :posts, as: :source
  has_many :post_groups, as: :group
  # User Subscribed for NewsCategory
  has_many :user_topic_subscriptions, as: :source, dependent: :destroy
  has_many :subscribed_users, through: :user_topic_subscriptions, source: :user
  
  # Fields validations
  validates :title, uniqueness: true, presence: true
  
  # Normalization
  def title=(value)
    super(value&.downcase&.strip)
  end
  
  def title
    self[:title] == 'general' ? 'news' : self[:title]
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
