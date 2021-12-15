# == Schema Information
#
# Table name: user_blocks
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  blocked_user_id :bigint           not null
#  blocker_user_id :bigint           not null
#
# Indexes
#
#  index_user_blocks_on_blocker_user_id_and_blocked_user_id  (blocker_user_id,blocked_user_id) UNIQUE
#
class UserBlock < ApplicationRecord
  # Constants
  
  # Callbacks
  
  # Associations
  belongs_to :blocker, foreign_key: :blocker_user_id, class_name: 'User'
  belongs_to :blocked, foreign_key: :blocked_user_id, class_name: 'User'
  
  # Associations validations
  
  # Fields validations
end
