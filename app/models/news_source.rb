class NewsSource < ApplicationRecord
  
  # Associations
  belongs_to :country
  has_many :news_articles
  
  # Fields validations
  validates :name, presence: true
  validates :source_identifier, presence: true, uniqueness: true
  
  def language=(value)
    super(value&.upcase)
  end
end
