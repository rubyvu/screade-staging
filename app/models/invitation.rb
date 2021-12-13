# == Schema Information
#
# Table name: invitations
#
#  id                 :bigint           not null, primary key
#  email              :string           not null
#  token              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  invited_by_user_id :bigint           not null
#  user_id            :bigint
#
# Indexes
#
#  index_invitations_on_invited_by_user_id  (invited_by_user_id)
#  index_invitations_on_user_id             (user_id)
#
class Invitation < ApplicationRecord
  # Constants
  
  # Callbacks
  
  # Associations
  belongs_to :invited_by_user, class_name: 'User', foreign_key: :invited_by_user_id
  
  # Associations Validations
  
  # Fields Validations
  validates :email, presence: true, length: { maximum: 100 }, format: { with: User::EMAIL_FORMAT }
end
