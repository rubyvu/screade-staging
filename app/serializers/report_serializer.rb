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
class ReportSerializer < ActiveModel::Serializer
  attribute :details
  attribute :id
  
  attribute :reported_user
  def reported_user
    current_user = instance_options[:current_user]
    UserProfileSerializer.new(object.reported, current_user: current_user).as_json
  end
end
