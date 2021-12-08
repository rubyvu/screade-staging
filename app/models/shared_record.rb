class SharedRecord < ApplicationRecord
  # Constants
  SHAREABLE_TYPES = %w(Comment NewsArticle Post)
  
  # Association
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :shareable, polymorphic: true
  has_and_belongs_to_many :users
  
  # Association validation
  validates :shareable_type, presence: true, inclusion: { in: SharedRecord::SHAREABLE_TYPES }
  
  # Validations
end
