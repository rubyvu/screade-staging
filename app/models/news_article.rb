class NewsArticle < ApplicationRecord
  
  # Associations
  belongs_to :country
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
end
