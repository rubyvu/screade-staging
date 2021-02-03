FactoryBot.define do
  factory :news_article do
    published_at { Faker::Time.between(from: DateTime.now - 10, to: DateTime.now + 10) }
    author { Faker::Artist.name }
    title { Faker::Lorem.characters(number: 10) }
    description { Faker::Lorem.characters(number: 40) }
    url { Faker::Internet.url + rand(1000).to_s }
    img_url { Faker::Internet.url }
  end
end
