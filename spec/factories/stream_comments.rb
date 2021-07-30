FactoryBot.define do
  factory :stream_comment do
    message { Faker::Lorem.characters(number: 10) }
  end
end
