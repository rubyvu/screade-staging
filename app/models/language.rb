class Language < ApplicationRecord
  # Constants
  LANGUAGES_FOR_WORLD_NEWS = %w(AR DE EN ES FR HE IT NL NO PT RU SE UD ZH)
  
  # Associations
  has_and_belongs_to_many :countries
  has_and_belongs_to_many :users
  has_many :news_sources
  
  # Fields validations
  validates :title, presence: true
  validates :code, presence: true, uniqueness: true
  
  # Normalization
  def code=(value)
    super(value&.upcase)
  end
end
