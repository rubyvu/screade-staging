FactoryBot.define do
  factory :topic do
    title { Faker::Lorem.characters(number: 10) }
    is_approved { false }
  end
end
