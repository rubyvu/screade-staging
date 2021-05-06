class Post < ApplicationRecord
  # Constants
  APPROVING_STATES = %w(pending approved)
  
  # File Uploader
  mount_uploader :image, PostImageUploader
  
  # Associations
  belongs_to :news_category
  belongs_to :topic
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
  
  # Association validations
  validates :news_category, presence: true
  validates :topic, presence: true
  validates :user, presence: true
  
  # Fields validations
  validates :title, presence: true
  validates :description, presence: true
  validates :state, presence: true, inclusion: { in: Post::APPROVING_STATES }
  
  def is_lited(user)
    user.present? && self.liting_users.include?(user)
  end
  
  def is_commented(user)
    user.present? && self.commenting_users.include?(user)
  end
  
  def is_viewed(user)
    user.present? && self.viewing_users.include?(user)
  end
end
