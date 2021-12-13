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
class EventSerializer < ActiveModel::Serializer
  attribute :id
  attribute :date
  def date
    object.start_date.strftime('%Y-%m-%d')
  end
  
  attribute :description
  attribute :end_date
  def end_date
    object.end_date.strftime('%Y-%m-%d %H:%M:%S %z')
  end
  
  attribute :start_date
  def start_date
    object.start_date.strftime('%Y-%m-%d %H:%M:%S %z')
  end
  
  attribute :title
end
