class NewsCategorySerializer < ActiveModel::Serializer
  attribute :id
  attribute :image
  attribute :title
  def title
    object.title.capitalize
  end
end
