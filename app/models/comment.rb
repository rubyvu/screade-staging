class Comment < ApplicationRecord
  SOURCE_TYPES = %w(NewsArticle)
  
  # Associations
  belongs_to :user
  belongs_to :source, polymorphic: true
  
  # Field validations
  validates :message, presence: true
  validates :source_id, presence: true
  validates :source_type, presence: true, inclusion: { in: Comment::SOURCE_TYPES }
end
