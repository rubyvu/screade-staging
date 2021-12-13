# == Schema Information
#
# Table name: comments
#
#  id          :bigint           not null, primary key
#  lits_count  :integer          default(0), not null
#  message     :text
#  source_type :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  comment_id  :integer
#  source_id   :integer          not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_comments_on_source_id  (source_id)
#
class Comment < ApplicationRecord
  SOURCE_TYPES = %w(NewsArticle Post)
  
  # Callbacks
  after_create :add_notification
  
  # Associations
  has_many :replied_comments, class_name: 'Comment', foreign_key: :comment_id, dependent: :destroy
  belongs_to :comment, class_name: 'Comment', foreign_key: :comment_id, optional: true
  ## Sharing
  has_many :shared_records, as: :shareable
  
  belongs_to :source, polymorphic: true, counter_cache: :comments_count
  belongs_to :user
  
  ## Lits
  has_many :lits, as: :source, dependent: :destroy
  has_many :liting_users, through: :lits, source: :user
  # Notifications
  has_many :notifications, as: :source, dependent: :destroy
  
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
    def add_notification
      # Do not send notification to yourself
      return if (self.comment_id.present? && self.comment.user == self.user) || (self.source_type == 'Post' && self.source.user == self.user)
      CreateNewNotificationJob.perform_later(self.id, self.class.name)
    end
    
    def replied_comment_only_for_comment
      return if self.comment.blank?
      self.errors.add(:base, 'You can create reply only from parent comment.') if self.comment.comment.present?
    end
end
