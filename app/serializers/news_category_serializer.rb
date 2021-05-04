class NewsCategorySerializer < ActiveModel::Serializer
  attribute :id
  attribute :image
  def image
    object.image.url
  end
  
  attribute :title
  def title
    object.title.capitalize
  end
end
