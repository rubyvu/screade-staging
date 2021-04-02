FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Lorem.characters(number: 18) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { Faker::Lorem.characters(number: 20) }
    security_question_answer { Faker::Lorem.characters(number: 20) }
  end
end
