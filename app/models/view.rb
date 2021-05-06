class View < ApplicationRecord
  
  SOURCE_TYPES = %w(NewsArticle)
  
  # Associations
  belongs_to :source, polymorphic: true, counter_cache: :views_count
  belongs_to :user
  
  # Field validations
  validates :source_id, presence: true, uniqueness: { scope: [:source_type, :user_id] }
  validates :source_type, presence: true, inclusion: { in: View::SOURCE_TYPES }
  validates :user_id, presence: true, uniqueness: { scope: [:source_type, :source_id] }
end
