# == Schema Information
#
# Table name: translations
#
#  id                :bigint           not null, primary key
#  field_name        :string           not null
#  result            :text
#  translatable_type :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  language_id       :bigint           not null
#  translatable_id   :bigint           not null
#
# Indexes
#
#  translations_unique_index  (translatable_id,translatable_type,language_id,field_name)
#
FactoryBot.define do
  factory :translation do
    result { Faker::Lorem.paragraph }
  end
end
