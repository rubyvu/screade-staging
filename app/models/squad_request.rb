class SquadRequest < ApplicationRecord
  
  # Associations
  belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id
  belongs_to :requestor, class_name: 'User', foreign_key: :requestor_id
  
  # Assosiations validations
  validates :receiver, presence: true, uniqueness: { scope: :requestor_id }
  validates :requestor, presence: true, uniqueness: { scope: :receiver_id }
  validate :receiver_as_requestor
  
  private
    def receiver_as_requestor
      return if self.receiver.blank? || self.requestor.blank?
      self.errors.add(:base, 'Receiver and requestor cannot be the same User') if self.receiver == self.requestor
    end
end
