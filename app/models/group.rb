class Group < ApplicationRecord
  # Constants
  DEFAULT_GROUPS = %w(news sports politics finance events beauty health)
  
  # Fields validations
  validates :title, uniqueness: true, presence: true, inclusion: { in: Group::DEFAULT_GROUPS, message: "New Group should exists in default groups list" }
  
  # Normalization
  def title=(value)
    super(value&.downcase&.strip)
  end
end
