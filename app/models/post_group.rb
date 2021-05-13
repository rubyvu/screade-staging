class PostGroup < ApplicationRecord
  
  # Constant
  GROUP_TYPES = %w(NewsCategory Topic)
  
  # Associations
  belongs_to :group, polymorphic: true
  belongs_to :post
  
  # Associations validations
  validates :group_id, presence: true
  validates :group_type, presence: true, inclusion: { in: PostGroup::GROUP_TYPES }
  validates :post_id, presence: true
end
