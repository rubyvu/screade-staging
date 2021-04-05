FactoryBot.define do
  factory :event do
    date { Faker::Date.between(from: DateTime.current, to: DateTime.current + 7.days) }
    start_date { Faker::Time.between(from: DateTime.current - 1.hour, to: DateTime.current) }
    end_date { Faker::Time.between(from: DateTime.current, to: DateTime.current + 1.hour) }
    title { Faker::Lorem.characters(number: 10) }
  end
end
