class NewsCategory < ApplicationRecord
  # Constants
  DEFAULT_CATEGORIES = %w(business entertainment general health science sports technology)
  
  # Associations
  has_and_belongs_to_many :news_articles
  
  # Fields validations
  validates :title, uniqueness: true, presence: true, inclusion: { in: NewsCategory::DEFAULT_CATEGORIES, message: "New category should exists in default categories list" }
  
  # Normalization
  def title=(value)
    super(value&.downcase&.strip)
  end
end
