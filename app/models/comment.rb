class Comment < ApplicationRecord
  SOURCE_TYPES = %w(NewsArticle)
  
  # Associations
  belongs_to :user
  belongs_to :source, polymorphic: true, counter_cache: :comments_count
  ## Lits
  has_many :lits, as: :source, dependent: :destroy
  has_many :liting_users, through: :lits, source: :user
  
  # Field validations
  validates :message, presence: true
  validates :source_id, presence: true
  validates :source_type, presence: true, inclusion: { in: Comment::SOURCE_TYPES }
  
  def is_lited(user)
    user.present? && self.liting_users.include?(user)
  end
end
