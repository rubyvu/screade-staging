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
FactoryBot.define do
  factory :event do
    start_date { Faker::Time.between(from: DateTime.current - 1.hour, to: DateTime.current) }
    end_date { Faker::Time.between(from: DateTime.current, to: DateTime.current + 1.hour) }
    title { Faker::Lorem.characters(number: 10) }
    description { Faker::Lorem.characters(number: 50) }
  end
end
