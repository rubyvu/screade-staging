# == Schema Information
#
# Table name: news_categories
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_news_categories_on_title  (title) UNIQUE
#
FactoryBot.define do
  factory :news_category do
    title { Faker::Lorem.characters(number: 30) }
  end
end
