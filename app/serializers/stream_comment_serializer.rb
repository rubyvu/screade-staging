class StreamCommentSerializer < ActiveModel::Serializer
  attribute :id
  attribute :message
  
  attribute :commentator
  def commentator
    current_user = instance_options[:current_user]
    UserProfileSerializer.new(object.user, current_user: current_user).as_json
  end
  
  attribute :created_at
  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S %z')
  end
  
  attribute :unix_created_at
  def unix_created_at
    object.created_at.in_time_zone('UTC').to_i
  end
end
