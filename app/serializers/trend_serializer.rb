class TrendSerializer < ActiveModel::Serializer
  attribute :id
  def id
    object.id
  end
  
  attribute :img_url
  def img_url
    case object.get_type
    when 'news_article'
      object.img_url
    else
      nil
    end
  end
  
  attribute :title
  def title
    case object.get_type
    when 'news_article'
      object.title
    else
      nil
    end
  end
  
  attribute :type
  def type
    object.get_type
  end
end
