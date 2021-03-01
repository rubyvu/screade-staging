class NewsArticle < ApplicationRecord
  
  # Associations
  belongs_to :country
  belongs_to :news_source, optional: true
  has_and_belongs_to_many :news_categories
  ## Comments
  has_many :comments, as: :source, dependent: :destroy
  has_many :commenting_users, through: :comments, source: :user
  ## Lits
  has_many :lits, as: :source, dependent: :destroy
  has_many :liting_users, through: :lits, source: :user
  ## Views
  has_many :views, as: :source, dependent: :destroy
  has_many :viewing_users, through: :views, source: :user
  
  # Association validation
  validates :country, presence: true
  
  # Fields validations
  validates :title, presence: true
  validates :published_at, presence: true
  validates :url, presence: true, uniqueness: true
  
  def get_type
    self.class.name.underscore
  end
  
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
