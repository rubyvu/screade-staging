class SquadRequestSerializer < ActiveModel::Serializer
  attribute :accepted_at
  attribute :declined_at
  attribute :id
  attribute :receiver
  def receiver
    UserProfileSerializer.new(object.receiver).as_json
  end
  
  attribute :requestor
  def requestor
    UserProfileSerializer.new(object.requestor).as_json
  end
end
