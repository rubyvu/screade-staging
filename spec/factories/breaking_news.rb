FactoryBot.define do
  factory :breaking_news do
    title { Faker::Lorem.characters(number: 10) }
  end
end
