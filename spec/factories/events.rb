FactoryBot.define do
  factory :event do
    start_date { Faker::Time.between(from: DateTime.current - 1.hour, to: DateTime.current) }
    end_date { Faker::Time.between(from: DateTime.current, to: DateTime.current + 1.hour) }
    title { Faker::Lorem.characters(number: 10) }
    description { Faker::Lorem.characters(number: 50) }
  end
end
