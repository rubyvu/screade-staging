# == Schema Information
#
# Table name: news_sources
#
#  id                :bigint           not null, primary key
#  name              :string
#  source_identifier :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  country_id        :integer          not null
#  language_id       :integer          not null
#
# Indexes
#
#  index_news_sources_on_country_id         (country_id)
#  index_news_sources_on_source_identifier  (source_identifier) UNIQUE
#
FactoryBot.define do
  factory :news_source do
    source_identifier { Faker::Lorem.characters(number: 30) }
    name { Faker::Lorem.characters(number: 30) }
  end
end
