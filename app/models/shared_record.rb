# == Schema Information
#
# Table name: shared_records
#
#  id             :bigint           not null, primary key
#  shareable_type :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  sender_id      :bigint           not null
#  shareable_id   :bigint           not null
#
# Indexes
#
#  index_shared_records_on_shareable_id_and_shareable_type  (shareable_id,shareable_type)
#
class SharedRecord < ApplicationRecord
  # Constants
  SHAREABLE_TYPES = %w(Comment NewsArticle Post)
  
  # Callbacks
  after_commit :add_notification, on: :create
  
  # Association
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :shareable, polymorphic: true
  has_and_belongs_to_many :users
  
  # Associations Validations
  validates :shareable_type, presence: true, inclusion: { in: SharedRecord::SHAREABLE_TYPES }
  
  # Fields Validations
  
  private
    def add_notification
      return unless sender && shareable && users.count > 0
      CreateNewNotificationJob.perform_later(self.id, self.class.name)
    end
end
