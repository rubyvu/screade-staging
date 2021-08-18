class TrendSerializer < ActiveModel::Serializer
  attribute :id
  def id
    case object.class.name
    when 'NewsArticle'
      object.id
    when 'Stream'
      object.access_token
    when 'Post'
      object.id
    end
  end
  
  attribute :img_url
  def img_url
    case object.class.name
    when 'NewsArticle'
      object.img_url
    when 'Stream'
      object.image.url
    when 'Post'
      object.image.url
    else
      nil
    end
  end
  
  attribute :title
  def title
    object.title || nil
  end
  
  attribute :type
  def type
    object.class.name
  end
end
