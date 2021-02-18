FactoryBot.define do
  factory :country do
    title { Faker::Lorem.characters(number: 10) }
    code { Country::COUNTRIES_WITH_NATIONAL_NEWS.sample }
  end
end
