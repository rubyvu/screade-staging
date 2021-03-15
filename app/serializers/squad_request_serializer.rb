class SquadRequestSerializer < ActiveModel::Serializer
  attribute :accepted_at
  attribute :declined_at
  attribute :receiver
  def receiver
    UserSerializer.new(object.receiver).as_json
  end
  
  attribute :requestor
  def requestor
    UserSerializer.new(object.requestor).as_json
  end
end
