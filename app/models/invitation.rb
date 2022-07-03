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
#
# Indexes
#
#  index_invitations_on_invited_by_user_id  (invited_by_user_id)
#  index_invitations_on_token               (token) UNIQUE
#
class Invitation < ApplicationRecord
  # Constants
  
  # Callbacks
  before_validation :generate_token, on: :create
  after_commit :notify_via_email, on: :create
  
  # Associations
  belongs_to :invited_by_user, class_name: 'User', foreign_key: :invited_by_user_id
  
  # Associations Validations
  
  # Fields Validations
  validates :email, presence: true, length: { maximum: 100 }, format: { with: User::EMAIL_FORMAT }
  validates :token, presence: true, uniqueness: true
  
  private
    def generate_token
      new_token = SecureRandom.alphanumeric(16)
      generate_token if Invitation.exists?(token: new_token)
      
      self.token = new_token
    end
    
    def notify_via_email
      SendInvitationEmailJob.perform_later(self.id)
    end
end
