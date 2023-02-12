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
#  index_news_articles_on_published_at       (published_at)
#  index_news_articles_on_url                (url) UNIQUE
#
class NewsArticle < ApplicationRecord
  # Search
  searchkick word_middle: [:title]
  
  # Hooks
  after_commit :tag_news_article, on: :create
  
  # Associations
  belongs_to :country
  belongs_to :news_source, optional: true
  has_and_belongs_to_many :news_categories
  has_and_belongs_to_many :topics
  ## Comments
  has_many :comments, as: :source, dependent: :destroy
  has_many :commenting_users, through: :comments, source: :user
  ## Lits
  has_many :lits, as: :source, dependent: :destroy
  has_many :liting_users, through: :lits, source: :user
  ## Sharing
  has_many :shared_records, as: :shareable
  ## Views
  has_many :views, as: :source, dependent: :destroy
  has_many :viewing_users, through: :views, source: :user
  
  # Association validation
  validates :country, presence: true
  
  # Fields validations
  validates :title, presence: true
  validates :published_at, presence: true
  validates :url, presence: true, uniqueness: true
  
  def get_type
    self.class.name.underscore
  end
  
  def is_lited(user)
    user.present? && self.liting_users.include?(user)
  end
  
  def is_commented(user)
    user.present? &&  self.commenting_users.include?(user)
  end
  
  def is_viewed(user)
    user.present? && self.viewing_users.include?(user)
  end
  
  def is_group_subscription(group)
    case group.class.name
    when 'NewsCategory'
      self.news_categories.include?(group)
    when 'Topic'
      self.topics.include?(group)
    else
      false
    end
  end
  
  def group_subscription_counts(group)
    self.news_categories.where(id: group.id).count + self.topics.where(id: group.approved_nested_topics_ids).count
  end
  
  private
    def tag_news_article
      TagNewsArticlesJob.perform_later(self.id)
    end
end
