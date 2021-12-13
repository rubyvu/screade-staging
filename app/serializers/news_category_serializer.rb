# == Schema Information
#
# Table name: news_categories
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_news_categories_on_title  (title) UNIQUE
#
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
