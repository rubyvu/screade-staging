class Lit < ApplicationRecord
  
  SOURCE_TYPES = %w(NewsArticle Comment)
  
  # Associations
  belongs_to :user
  belongs_to :source, polymorphic: true
  
  # Field validations
  validates :source_id, presence: true, uniqueness: { scope: [:source_type, :user_id] }
  validates :source_type, presence: true, inclusion: { in: Lit::SOURCE_TYPES }
end
