class NewsCategorySerializer < ActiveModel::Serializer
  attribute :id
  attribute :title
  def title
    object.title.capitalize
  end
end
