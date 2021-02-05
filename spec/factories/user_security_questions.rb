FactoryBot.define do
  factory :user_security_question do
    title { Faker::Lorem.characters(number: 20) }
    question_identifier { Faker::Lorem.characters(number: 20) }
  end
end
