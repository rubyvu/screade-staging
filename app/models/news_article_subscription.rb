class NewsArticleSubscription < ApplicationRecord
  SOURCE_TYPES = %w(NewsCategory Topic)
  
  # Associations
  belongs_to :source, polymorphic: true
  belongs_to :news_article
  
  # Field validations
  validates :source_id, presence: true, uniqueness: { scope: [:source_type, :news_article_id] }
  validates :source_type, presence: true, inclusion: { in: NewsArticleSubscription::SOURCE_TYPES }
  validates :news_article_id, presence: true, uniqueness: { scope: [:source_type, :source_id] }
end
