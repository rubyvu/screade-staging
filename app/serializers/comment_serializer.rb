class CommentSerializer < ActiveModel::Serializer
  attribute :id
  attribute :message
  attribute :created_at
  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S %z')
  end
  
  attribute :commentator
  def commentator
    UserSerializer.new(object.user).as_json
  end
end
