class Country < ApplicationRecord
  # Constants
  COUNTRIES_WITH_NATIONAL_NEWS = %w(AE AR AT AU BE BG BR CA CH CN CO CU CZ DE EG FR GB GR HK HU ID IE IL IN IT JP KR LT LV MA MX MY NG NL NO NZ PH PL PT RO RS RU SA SE SG SI SK TH TR TW UA US VE ZA)
  
  # Associations
  has_many :news_articles, class_name: 'NewsArticle'
  has_many :news_sources, class_name: 'NewsSource'
  has_many :users, class_name: 'User'
  has_and_belongs_to_many :languages
  
  # Fields validations
  validates :title, presence: true
  validates :code, presence: true, uniqueness: true
  
  # Normalization
  def code=(value)
    super(value&.upcase)
  end
end
