class View < ApplicationRecord
  
  SOURCE_TYPES = %w(NewsArticle)
  
  # Associations
  belongs_to :user
  belongs_to :source, polymorphic: true
  
  # Field validations
  validates :source_id, presence: true, uniqueness: { scope: :source_type }
  validates :source_type, presence: true, inclusion: { in: View::SOURCE_TYPES }
end
