class NewsCategorySerializer < ActiveModel::Serializer
  attribute :id
  attribute :image
  def image
    object.image_url
  end
  
  attribute :title
  def title
    object.title.capitalize
  end
end
