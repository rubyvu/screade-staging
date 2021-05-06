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
