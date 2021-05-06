FactoryBot.define do
  factory :news_category do
    title { Faker::Lorem.characters(number: 30) }
  end
end
