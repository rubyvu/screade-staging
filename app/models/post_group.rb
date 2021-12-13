# == Schema Information
#
# Table name: post_groups
#
#  id         :bigint           not null, primary key
#  group_type :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer          not null
#  post_id    :integer          not null
#
# Indexes
#
#  index_post_groups_on_post_id  (post_id)
#
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
