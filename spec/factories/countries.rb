FactoryBot.define do
  factory :country do
    title { Faker::Lorem.characters(number: 10) }
    code { Country::DEFAULT_COUNTRIES.sample }
  end
end
