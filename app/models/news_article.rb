class NewsArticle < ApplicationRecord
  
  # Associations
  has_and_belongs_to_many :news_categories
  belongs_to :country
  
  # Association validation
  validates :country, presence: true
  validates :news_category, presence: true
  
  # Fields validations
  validates :title, presence: true
  validates :published_at, presence: true
  validates :url, presence: true, uniqueness: true
end
