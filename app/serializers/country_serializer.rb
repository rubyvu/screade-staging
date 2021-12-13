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
class CountrySerializer < ActiveModel::Serializer
  attribute :title
  attribute :code
end
