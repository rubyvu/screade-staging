class StreamSerializer < ActiveModel::Serializer
  attribute :access_token
  
  attribute :created_at
  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S %z')
  end
  
  attribute :error_message
  attribute :group_id
  attribute :group_type
  attribute :is_private
  
  attribute :is_commented
  def is_commented
    current_user = instance_options[:current_user]
    current_user && current_user.kind_of?(User) ? object.is_commented(current_user) : false
  end
  
  attribute :is_lited
  def is_lited
    current_user = instance_options[:current_user]
    current_user && current_user.kind_of?(User) ? object.is_lited(current_user) : false
  end
  
  attribute :is_viewed
  def is_viewed
    current_user = instance_options[:current_user]
    current_user && current_user.kind_of?(User) ? object.is_viewed(current_user) : false
  end
  
  attribute :image
  def image
    object&.image_url
  end
  
  attribute :lits_count
  def lits_count
    object.lits_count
  end
  
  attribute :owner
  def owner
    current_user = instance_options[:current_user]
    UserProfileSerializer.new(object.owner, current_user: current_user).as_json
  end
  
  attribute :playback_url
  attribute :status
  
  attribute :stream_comments_count
  def stream_comments_count
    object.stream_comments_count
  end
  
  attribute :rtmp_url
  def rtmp_url
    current_user = instance_options[:current_user]
    if object.owner == current_user && object.mux_stream_key
      "rtmps://global-live.mux.com:443/app/#{object.mux_stream_key}"
    else
      nil
    end
  end
  
  attribute :title
  
  attribute :video
  def video
    object.video_url
  end
  
  attribute :views_count
  def views_count
    object.views_count
  end
end
