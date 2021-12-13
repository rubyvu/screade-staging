# == Schema Information
#
# Table name: stream_comments
#
#  id         :bigint           not null, primary key
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  stream_id  :integer
#  user_id    :integer
#
# Indexes
#
#  index_stream_comments_on_user_id  (user_id)
#
class StreamCommentSerializer < ActiveModel::Serializer
  attribute :commentator
  def commentator
    current_user = instance_options[:current_user]
    UserProfileSerializer.new(object.user, current_user: current_user).as_json
  end
  
  attribute :created_at
  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S %z')
  end
  
  attribute :id
  attribute :message
  attribute :stream_access_token
  def stream_access_token
    object.stream.access_token
  end
  
  attribute :unix_created_at
  def unix_created_at
    object.created_at.in_time_zone('UTC').to_i
  end
end
