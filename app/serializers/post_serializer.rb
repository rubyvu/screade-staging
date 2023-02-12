# == Schema Information
#
# Table name: posts
#
#  id                :bigint           not null, primary key
#  comments_count    :integer          default(0), not null
#  description       :text             not null
#  detected_language :string
#  is_approved       :boolean          default(TRUE)
#  is_notification   :boolean          default(TRUE)
#  lits_count        :integer          default(0), not null
#  source_type       :string           not null
#  title             :string           not null
#  views_count       :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  source_id         :integer          not null
#  user_id           :integer          not null
#
# Indexes
#
#  index_posts_on_detected_language  (detected_language)
#
class PostSerializer < ActiveModel::Serializer
  attribute :comments_count
  def comments_count
    object.comments.count
  end
  
  attribute :created_at
  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S %z')
  end
  
  attribute :description
  attribute :id
  
  attribute :image
  def image
    object.image.url
  end
  
  attribute :is_notification
  def is_notification
    current_user = instance_options[:current_user]
    current_user == object.user ? object.is_notification : nil
  end
  
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
  
  attribute :lits_count
  def lits_count
    object.lits.count
  end
  
  attribute :source
  def source
    PostGroupSerializer.new(object.source).as_json
  end
  
  attribute :title
  attribute :is_approved
  
  attribute :video
  def video
    object.video.url
  end
  
  attribute :video_thumbnail_url
  def video_thumbnail_url
    object.video.preview(resize_to_limit: [300, 300]).processed.url if object.video.attached?
  end
  
  attribute :views_count
  def views_count
    object.views.count
  end
  
  attribute :user
  def user
    current_user = instance_options[:current_user]
    UserProfileSerializer.new(object.user, current_user: current_user).as_json
  end
end
