FactoryBot.define do
  factory :language do
    title { Faker::Lorem.characters(number: 10) }
    code { Language::LANGUAGES_FOR_WORLD_NEWS.sample }
  end
end
