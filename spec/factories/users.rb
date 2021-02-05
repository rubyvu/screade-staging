FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.username + rand(100).to_s }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    password { Faker::Internet.password }
    security_question_answer { Faker::Lorem.characters(number: 20) }
  end
end
