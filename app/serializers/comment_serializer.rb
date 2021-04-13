class CommentSerializer < ActiveModel::Serializer
  attribute :id
  attribute :message
  attribute :created_at
  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S %z')
  end
  
  attribute :commentator
  def commentator
    current_user = instance_options[:current_user]
    UserProfileSerializer.new(object.user, current_user: current_user).as_json
  end
  
  attribute :comment_id
  attribute :is_lited
  def is_lited
    current_user = instance_options[:current_user]
    current_user && current_user.kind_of?(User) ? object.is_lited(current_user) : false
  end
  
  attribute :lits_count
  def lits_count
    object.lits.count
  end
  
  attribute :replied_comments
  def replied_comments
    current_user = instance_options[:current_user]
    ActiveModel::Serializer::CollectionSerializer.new(object.replied_comments.order(created_at: :desc), serializer: CommentSerializer, current_user: current_user).as_json
  end
end
