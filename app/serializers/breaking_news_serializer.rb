class BreakingNewsSerializer < ActiveModel::Serializer
  attribute :title
  def title
    object.post&.title
  end
  
  attribute :post_id
end
