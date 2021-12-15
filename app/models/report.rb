# == Schema Information
#
# Table name: reports
#
#  id               :bigint           not null, primary key
#  details          :text             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  reported_user_id :bigint           not null
#  reporter_user_id :bigint           not null
#
# Indexes
#
#  index_reports_on_reported_user_id  (reported_user_id)
#  index_reports_on_reporter_user_id  (reporter_user_id)
#
class Report < ApplicationRecord
  # Constants
  
  # Callbacks
  
  # Associations
  belongs_to :reporter, foreign_key: :reporter_user_id, class_name: 'User'
  belongs_to :reported, foreign_key: :reported_user_id, class_name: 'User'
  
  # Associations validations
  
  # Fields validations
  validates :details, presence: true
end
