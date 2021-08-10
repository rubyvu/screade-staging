class StreamCommentSerializer < ActiveModel::Serializer
  attribute :access_token
  attribute :channel_id
  attribute :channel_input_id
  attribute :channel_security_group_id
  
  attribute :created_at
  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S %z')
  end
  
  attribute :error_message
  attribute :group_id
  attribute :group_type
  attribute :is_private
  
  attribute :image
  def image
    object&.image&.rectangle_300_250&.url
  end
  
  attribute :status
  attribute :stream_url
  attribute :rtmp_url
  attribute :title
  
  attribute :user
  def user
    current_user = instance_options[:current_user]
    UserProfileSerializer.new(object.user, current_user: current_user).as_json
  end
  
  attribute :video
  def video
    object.video&.url
  end
end
