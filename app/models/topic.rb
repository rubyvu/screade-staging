class Topic < ApplicationRecord
  
  # Constants
  PARENT_TYPES = %w(Topic NewsCategory)
  
  # Callbacks
  before_validation :set_nesting_position
  
  # Associations
  has_many :sub_topics, class_name: 'Topic', foreign_key: :parent_id, dependent: :destroy
  belongs_to :parent, class_name: 'Topic', foreign_key: :parent_id, polymorphic: true
  
  # Field validations
  validates :nesting_position, presence: true, numericality: { less_than_or_equal_to: 2,  only_integer: true }
  validates :parent_id, presence: true
  validates :parent_type, presence: true, inclusion: { in: Topic::PARENT_TYPES }
  validate :assigned_to_itself
  
  private
    def assigned_to_itself
      errors.add(:base, 'Topic cannot be assigned to itself') if self.id == parent_id && parent_type == 'Topic'
    end
    
    def set_nesting_position
      return unless parent_id
      if self.parent_type == 'NewsCategory'
        self.nesting_position = 0
      else
        self.nesting_position = self.parent.nesting_position + 1
      end
    end
end
