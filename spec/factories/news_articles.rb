# == Schema Information
#
# Table name: news_articles
#
#  id                :bigint           not null, primary key
#  author            :string
#  comments_count    :integer          default(0), not null
#  description       :text
#  detected_language :string
#  img_url           :string
#  lits_count        :integer          default(0), not null
#  published_at      :datetime         not null
#  title             :string           not null
#  url               :string           not null
#  views_count       :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  country_id        :integer          not null
#  news_source_id    :integer
#
# Indexes
#
#  index_news_articles_on_country_id         (country_id)
#  index_news_articles_on_detected_language  (detected_language)
#  index_news_articles_on_lits_count         (lits_count)
#  index_news_articles_on_url                (url) UNIQUE
#
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
