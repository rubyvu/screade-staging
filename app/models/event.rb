# == Schema Information
#
# Table name: events
#
#  id          :bigint           not null, primary key
#  description :text             not null
#  end_date    :datetime         not null
#  start_date  :datetime         not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_events_on_user_id  (user_id)
#
class Event < ApplicationRecord
  
  # Associations
  belongs_to :user
  
  ## Notifications
  has_many :notifications, as: :source, dependent: :destroy
  
  # Association validation
  validates :user, presence: true
  
  # Field validations
  validates :description, presence: true
  validates :end_date, presence: true
  validates :start_date, presence: true
  validates :title, presence: true
  validate :stat_date_greater_than_end_date
  
  private
    def stat_date_greater_than_end_date
      return if start_date.blank? || end_date.blank?
      self.errors.add(:end_date, 'should be grater than start date') if self.start_date > self.end_date
    end
end
