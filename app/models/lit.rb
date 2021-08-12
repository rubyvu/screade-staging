class Lit < ApplicationRecord
  
  SOURCE_TYPES = %w(NewsArticle Comment Post Stream)
  
  # Associations
  belongs_to :source, polymorphic: true, counter_cache: :lits_count
  belongs_to :user
  
  # Field validations
  validates :source_id, presence: true, uniqueness: { scope: [:source_type, :user_id] }
  validates :source_type, presence: true, inclusion: { in: Lit::SOURCE_TYPES }
  validates :user_id, presence: true, uniqueness: { scope: [:source_type, :source_id] }
end
