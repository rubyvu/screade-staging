# == Schema Information
#
# Table name: news_articles
#
#  id                :bigint           not null, primary key
#  author            :string
#  comments_count    :integer          default(0), not null
#  description       :text
#  detected_language :string
#  img_url           :string
#  lits_count        :integer          default(0), not null
#  published_at      :datetime         not null
#  title             :string           not null
#  url               :string           not null
#  views_count       :integer          default(0), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  country_id        :integer          not null
#  news_source_id    :integer
#
# Indexes
#
#  index_news_articles_on_country_id         (country_id)
#  index_news_articles_on_detected_language  (detected_language)
#  index_news_articles_on_lits_count         (lits_count)
#  index_news_articles_on_url                (url) UNIQUE
#
class NewsArticleSerializer < ActiveModel::Serializer
  attribute :comments_count
  def comments_count
    object.comments.count
  end
  
  attribute :description
  attribute :img_url
  attribute :id
  
  attribute :is_commented
  def is_commented
    current_user = instance_options[:current_user]
    current_user && current_user.kind_of?(User) ? object.is_commented(current_user) : false
  end
  
  attribute :is_lited
  def is_lited
    current_user = instance_options[:current_user]
    current_user && current_user.kind_of?(User) ? object.is_lited(current_user) : false
  end
  
  attribute :is_viewed
  def is_viewed
    current_user = instance_options[:current_user]
    current_user && current_user.kind_of?(User) ? object.is_viewed(current_user) : false
  end
  
  attribute :lits_count
  def lits_count
    object.lits.count
  end
  
  attribute :title
  
  attribute :views_count
  def views_count
    object.views.count
  end
  
  attribute :url
end
