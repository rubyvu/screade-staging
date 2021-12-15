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
class Translation < ApplicationRecord
  # Constants
  
  # Callbacks
  
  # Associations
  belongs_to :language
  belongs_to :translatable, polymorphic: true
  
  # Associations validations
  validates :field_name, uniqueness: { scope: [:translatable_id, :translatable_type, :language_id] }
  
  # Fields validations
  validates :field_name, presence: true
end
