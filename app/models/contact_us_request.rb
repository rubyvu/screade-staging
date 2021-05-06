class ContactUsRequest < ApplicationRecord
  after_create :send_email_to_admins
  
  # Fields Validation
  validates :email, presence: true, length: { maximum: 100 }, format: { with: User::EMAIL_FORMAT }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :message, presence: true
  validates :subject, presence: true
  validates :username, presence: true
  
  private
    def send_email_to_admins
      ContactUsRequestJob.perform_later(self.id)
    end
end
