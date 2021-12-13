# == Schema Information
#
# Table name: languages
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_languages_on_code  (code) UNIQUE
#
FactoryBot.define do
  factory :language do
    title { Faker::Lorem.characters(number: 10) }
    code { Language::LANGUAGES_FOR_WORLD_NEWS.sample }
  end
end
