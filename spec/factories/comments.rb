FactoryBot.define do
  factory :comment do
    message { Faker::Lorem.characters(number: 30) }
  end
end
