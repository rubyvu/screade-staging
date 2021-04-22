class Topic < ApplicationRecord
  
  # Constants
  PARENT_TYPES = %w(Topic NewsCategory)
  
  # Callbacks
  before_validation :set_nesting_position
  after_update :unapprove_topic
  
  # Associations
  has_many :sub_topics, -> (topic) { where(parent_type: 'Topic') }, class_name: 'Topic', foreign_key: :parent_id, dependent: :destroy
  
  # User Subscripted for Topic
  has_many :user_topic_subscriptions, as: :source, dependent: :destroy
  has_many :subscripted_users, through: :user_topic_subscriptions, source: :user
  # News Article Subscriptions
  has_and_belongs_to_many :news_articles
  
  belongs_to :parent, class_name: 'Topic', foreign_key: :parent_id, polymorphic: true
  
  # Field validations
  validates :nesting_position, presence: true, numericality: { less_than_or_equal_to: 2,  only_integer: true }
  validates :parent_id, presence: true
  validates :parent_type, presence: true, inclusion: { in: Topic::PARENT_TYPES }
  validates :title, presence: true, uniqueness: { scope: :parent_id }
  validate :assigned_to_itself
  validate :parent_is_approved
  
  private
    def assigned_to_itself
      errors.add(:base, 'Topic cannot be assigned to itself') if self.id == parent_id && parent_type == 'Topic'
    end
    
    def parent_is_approved
      errors.add(:is_approved, 'cannot be change untill Parent is not approved') if self.parent_type == 'Topic' && self.will_save_change_to_is_approved? && self.is_approved && !self.parent.is_approved
    end
    
    def set_nesting_position
      return unless parent_id
      if self.parent_type == 'NewsCategory'
        self.nesting_position = 0
      else
        self.nesting_position = self.parent.nesting_position + 1
      end
    end
    
    def unapprove_topic
      unaprove_sub_topis(self) if self.saved_change_to_is_approved? && !self.is_approved && self.nesting_position < 2
    end
    
    def unaprove_sub_topis(topic)
      # Update each Topic SubTopics
      topic.sub_topics.where(is_approved: true).each do |sub_topic|
        sub_topic.update_columns(is_approved: false)
        unaprove_sub_topis(sub_topic)
      end
    end
end
