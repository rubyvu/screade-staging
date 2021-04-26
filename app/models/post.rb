class Post < ApplicationRecord
  
  # File Uploader
  mount_uploader :image, PostImageUploader
  
  # Associations
  belongs_to :user
  belongs_to :news_category
  belongs_to :topic
  ## Comments
  has_many :comments, as: :source, dependent: :destroy
  has_many :commenting_users, through: :comments, source: :user
  ## Lits
  has_many :lits, as: :source, dependent: :destroy
  has_many :liting_users, through: :lits, source: :user
  ## Views
  has_many :views, as: :source, dependent: :destroy
  has_many :viewing_users, through: :views, source: :user
  
  # Fields validations
  validates :title, presence: true
  validates :description, presence: true
  validates :image, presence: true
  validates :is_notified
  
  def is_lited(user)
    user.present? && self.liting_users.include?(user)
  end
  
  def is_commented(user)
    user.present? &&  self.commenting_users.include?(user)
  end
  
  def is_viewed(user)
    user.present? && self.viewing_users.include?(user)
  end
end
