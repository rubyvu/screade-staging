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
class NewsSource < ApplicationRecord
  
  # Associations
  belongs_to :country
  belongs_to :language
  has_many :news_articles
  
  # Fields validations
  validates :name, presence: true
  validates :source_identifier, presence: true, uniqueness: true
end
