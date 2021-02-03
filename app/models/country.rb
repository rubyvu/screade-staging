class Country < ApplicationRecord
  # Constants
  DEFAULT_COUNTRIES = %w(ae ar at au be bg br ca ch cn co cu cz de eg fr gb gr hk hu id ie il in it jp kr lt lv ma mx my ng nl no nz ph pl pt ro rs ru sa se sg si sk th tr tw ua us ve za)
  
  # Associations
  has_many :news_articles, class_name: 'NewsArticle'
  
  # Fields validations
  validates :title, presence: true
  validates :code, presence: true, uniqueness: true, inclusion: { in: Country::DEFAULT_COUNTRIES, message: "New category should exists in default categories list" }
  
  # Normalization
  def code=(value)
    super(value&.downcase)
  end
end
