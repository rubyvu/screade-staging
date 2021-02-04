class NewsArticle < ApplicationRecord
  
  # Associations
  belongs_to :country
  belongs_to :news_category
  
  # Association validation
  validates :country, presence: true
  validates :news_category, presence: true
  
  # Fields validations
  validates :title, presence: true
  validates :published_at, presence: true
  validates :url, presence: true, uniqueness: true
end
