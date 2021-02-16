class NewsArticleSerializer < ActiveModel::Serializer
  attribute :title
  attribute :img_url
  attribute :url
end
