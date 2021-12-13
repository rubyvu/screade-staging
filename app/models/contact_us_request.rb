# == Schema Information
#
# Table name: contact_us_requests
#
#  id          :bigint           not null, primary key
#  email       :string           not null
#  first_name  :string           not null
#  last_name   :string           not null
#  message     :text             not null
#  resolved_at :datetime
#  resolved_by :string
#  subject     :string           not null
#  username    :string           not null
#  version     :string           default("0")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
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
