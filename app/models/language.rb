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
