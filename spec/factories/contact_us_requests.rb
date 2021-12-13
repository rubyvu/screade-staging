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
FactoryBot.define do
  factory :contact_us_request do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { Faker::Lorem.characters(number: 18) }
    email { Faker::Internet.email }
    subject { Faker::Lorem.characters(number: 10) }
    message { Faker::Lorem.characters(number: 20) }
  end
end
