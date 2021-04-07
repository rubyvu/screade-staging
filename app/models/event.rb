class Event < ApplicationRecord
  
  # Associations
  belongs_to :user
  
  # Association validation
  validates :user, presence: true
  
  # Field validations
  validates :date, presence: true
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
