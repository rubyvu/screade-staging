# == Schema Information
#
# Table name: countries
#
#  id               :bigint           not null, primary key
#  code             :string           not null
#  is_national_news :boolean          default(FALSE)
#  title            :string           not null
#
# Indexes
#
#  index_countries_on_code  (code) UNIQUE
#
FactoryBot.define do
  factory :country do
    title { Faker::Lorem.characters(number: 10) }
    code { Country::COUNTRIES_WITH_NATIONAL_NEWS.sample }
  end
end
