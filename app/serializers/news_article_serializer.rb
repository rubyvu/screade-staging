class NewsArticleSerializer < ActiveModel::Serializer
  attribute :comments_count
  def comments_count
    object.comments.count
  end
  
  attribute :description
  attribute :img_url
  
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
  
  attribute :title
  
  attribute :views_count
  def views_count
    object.views.count
  end
  
  attribute :url
end
