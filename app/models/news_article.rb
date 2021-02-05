class NewsArticle < ApplicationRecord
  
  # Associations
  belongs_to :country
  has_and_belongs_to_many :news_categories
  # Lits
  has_many :lits, as: :source, dependent: :destroy
  has_many :liting_users, through: :lits, source: :user
  
  # Association validation
  validates :country, presence: true
  
  # Fields validations
  validates :title, presence: true
  validates :published_at, presence: true
  validates :url, presence: true, uniqueness: true
end
