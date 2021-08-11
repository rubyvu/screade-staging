class StreamSerializer < ActiveModel::Serializer
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
    object&.image&.rectangle_300_250&.url
  end
  
  attribute :lits_count
  def lits_count
    object.lits.count
  end
  
  attribute :owner
  def owner
    current_user = instance_options[:current_user]
    UserProfileSerializer.new(object.owner, current_user: current_user).as_json
  end
  
  attribute :status
  attribute :stream_url
  
  attribute :stream_comments_count
  def stream_comments_count
    object.stream_comments.count
  end
  
  attribute :rtmp_url
  attribute :title
  
  attribute :video
  def video
    object.video&.url
  end
  
  attribute :views_count
  def views_count
    object.views.count
  end
end
