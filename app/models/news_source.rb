class NewsSource < ApplicationRecord
  
  # Associations
  belongs_to :country
  belongs_to :language
  has_many :news_articles
  
  # Fields validations
  validates :name, presence: true
  validates :source_identifier, presence: true, uniqueness: true
end
