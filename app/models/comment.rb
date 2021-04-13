class Comment < ApplicationRecord
  SOURCE_TYPES = %w(NewsArticle)
  
  # Associations
  has_many :replied_comments, class_name: 'Comment', foreign_key: :comment_id, dependent: :destroy
  belongs_to :comment, class_name: 'Comment', foreign_key: :comment_id, optional: true
  belongs_to :source, polymorphic: true, counter_cache: :comments_count
  belongs_to :user
  ## Lits
  has_many :lits, as: :source, dependent: :destroy
  has_many :liting_users, through: :lits, source: :user
  
  # Field validations
  validates :message, presence: true
  validates :source_id, presence: true
  validates :source_type, presence: true, inclusion: { in: Comment::SOURCE_TYPES }
  validates :user_id, presence: true
  validate :replied_comment_only_for_comment
  
  def is_lited(user)
    user.present? && self.liting_users.include?(user)
  end
  
  private
    def replied_comment_only_for_comment
      return if self.comment.blank?
      self.errors.add(:base, 'You can create reply only from parent comment.') if self.comment.comment.present?
    end
end
