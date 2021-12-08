class Post < ApplicationRecord
  # Search
  searchkick text_middle: [:title]
  
  # Constants
  SOURCE_TYPES = %w(NewsCategory Topic)
  
  # Callbacks
  after_save :update_associated_groups
  after_save :add_notification
  
  # File Uploader
  has_one_attached :image
  
  # Associations
  belongs_to :source, polymorphic: true
  belongs_to :user
  
  ## Comments
  has_many :comments, as: :source, dependent: :destroy
  has_many :commenting_users, through: :comments, source: :user
  ## Lits
  has_many :lits, as: :source, dependent: :destroy
  has_many :liting_users, through: :lits, source: :user
  ## Views
  has_many :views, as: :source, dependent: :destroy
  has_many :viewing_users, through: :views, source: :user
  # Notifications
  has_many :notifications, as: :source, dependent: :destroy
  # Extra Group assiciation
  has_many :post_groups, dependent: :destroy
  ## Sharing
  has_many :shared_records, as: :shareable
  
  # Association validations
  validates :user, presence: true
  
  # Fields validations
  validates :title, presence: true
  validates :description, presence: true
  validates :source_id, presence: true
  validates :source_type, presence: true, inclusion: { in: Post::SOURCE_TYPES }
  
  def is_lited(user)
    user.present? && self.liting_users.include?(user)
  end
  
  def is_commented(user)
    user.present? && self.commenting_users.include?(user)
  end
  
  def is_viewed(user)
    user.present? && self.viewing_users.include?(user)
  end
  
  def image_url
    self.image.url if self.image.attached?
  end
  
  private
    def add_notification
      return if !self.is_approved || Notification.where(source_id: self.id, source_type: 'Post', sender: self.user).present? || !self.is_notification
      CreateNewNotificationJob.perform_later(self.id, self.class.name)
    end
    
    def update_associated_groups
      return unless saved_change_to_source_id? || saved_change_to_source_type?
      
      # Clear old associations
      self.post_groups.destroy_all
      
      # Create new associations
      associate_topic_with_post(self.source)
    end
    
    def associate_topic_with_post(group)
      PostGroup.create(group: group, post: self)
      associate_topic_with_post(group.parent) if group.class.name == 'Topic'
    end
end
