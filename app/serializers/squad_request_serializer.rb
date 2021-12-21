# == Schema Information
#
# Table name: squad_requests
#
#  id           :bigint           not null, primary key
#  accepted_at  :datetime
#  declined_at  :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  receiver_id  :integer
#  requestor_id :integer
#
# Indexes
#
#  index_squad_requests_on_receiver_id_and_requestor_id  (receiver_id,requestor_id)
#
class SquadRequestSerializer < ActiveModel::Serializer
  attribute :accepted_at
  attribute :declined_at
  attribute :id
  
  attribute :receiver
  def receiver
    current_user = instance_options[:current_user]
    UserProfileSerializer.new(object.receiver, current_user: current_user).as_json
  end
  
  attribute :requestor
  def requestor
    current_user = instance_options[:current_user]
    UserProfileSerializer.new(object.requestor, current_user: current_user).as_json
  end
end
