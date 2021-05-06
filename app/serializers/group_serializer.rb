class GroupSerializer < ActiveModel::Serializer
  
  attribute :type
  def type
    object.class.name
  end
  
  attribute :id
  attribute :title
  attribute :image
  def image
    object.class.name == 'NewsCategory' ? object.image.url : nil
  end
  
  attribute :is_subscription
  def is_subscription
    current_user = instance_options[:current_user]
    news_article = instance_options[:news_article]
    if news_article
      news_article.is_group_subscription(object)
    else
      current_user.is_group_subscription(object)
    end
  end
  
  attribute :subscriptions_count
  def subscriptions_count
    if object.class.name == 'NewsCategory'
      current_user = instance_options[:current_user]
      news_article = instance_options[:news_article]
      if news_article
        news_article.group_subscription_counts(object)
      else
        current_user.group_subscription_counts(object)
      end
    else
      nil
    end
  end
  
  attribute :parent_type
  def parent_type
    if object.class.name == 'Topic'
      object.parent_type
    else
      nil
    end
  end
  
  attribute :parent_id
  def parent_id
    if object.class.name == 'Topic'
      object.parent_id
    else
      nil
    end
  end
  
  attribute :nesting_position
  def nesting_position
    if object.class.name == 'Topic'
      object.nesting_position+1
    else
      0
    end
  end
end
