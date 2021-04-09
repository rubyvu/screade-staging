class SquadRequestSerializer < ActiveModel::Serializer
  attribute :accepted_at
  attribute :declined_at
  attribute :id
  attribute :receiver
  def receiver
    UserProfileSerializer.new(object.receiver, current_user: instance_options[:current_user]).as_json
  end
  
  attribute :requestor
  def requestor
    UserProfileSerializer.new(object.requestor, current_user: instance_options[:current_user]).as_json
  end
end
