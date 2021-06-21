FactoryBot.define do
  factory :post do
    title { Faker::Lorem.characters(number: 10) }
    description { Faker::Lorem.characters(number: 50) }
  end
end
