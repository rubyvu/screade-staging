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
class LanguageSerializer < ActiveModel::Serializer
  attribute :id
  attribute :title
  attribute :code
end
