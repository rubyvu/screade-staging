FactoryBot.define do
  factory :news_source do
    source_identifier { Faker::Lorem.characters(number: 30) }
    name { Faker::Lorem.characters(number: 30) }
  end
end
