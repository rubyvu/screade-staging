FactoryBot.define do
  factory :stream do
    title { Faker::Lorem.characters(number: 10) }
  end
end
