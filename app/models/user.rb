class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable, :trackable and :omniauthable
  devise :confirmable, :database_authenticatable, :lockable, :registerable, :recoverable, :validatable, authentication_keys: [:login]
  
  # Search
  searchkick word_middle: [:first_name, :last_name, :username]
  
  # Constants
  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  PASSWORD_FORMAT = /\A(?=.*[^a-zA-Z])/i  # Must contain at least one number or symbol
  USERNAME_FORMAT = /\A[a-zA-Z0-9](_(?!(\.|_))|\.(?!(_|\.))|[a-zA-Z0-9]){4,16}[a-zA-Z0-9]/i  #  Can contain characters from 6 to 18 symbols, allowed _(underscore) and .(dot) symbols
  USERNAME_ROUTE_FORMAT = /[^\/]+/  # Alow .(dot) in username for URL
  
  # File Uploader
  mount_uploader :profile_picture, AvatarUploader
  mount_uploader :banner_picture, BannerUploader
  
  # Callbacks
  after_commit :set_user_settings, on: [:create]
  
  # Associations
  belongs_to :country
  belongs_to :user_security_question
  has_one :setting, dependent: :destroy
  has_many :devices, class_name: 'Device', foreign_key: 'owner_id', dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :post_groups, through: :posts
  ## Squad requests
  has_many :squad_requests_as_receiver, foreign_key: :receiver_id, class_name: 'SquadRequest', dependent: :destroy
  has_many :squad_requests_as_requestor, foreign_key: :requestor_id, class_name: 'SquadRequest', dependent: :destroy
  ## Comments
  has_many :comments, dependent: :destroy
  has_many :commented_news_articles, through: :comments, source: :source, source_type: 'NewsArticle'
  ## Lits
  has_many :lits, dependent: :destroy
  has_many :lited_news_articles, through: :lits, source: :source, source_type: 'NewsArticle'
  ## Views
  has_many :views, dependent: :destroy
  has_many :viewed_news_articles, through: :views, source: :source, source_type: 'NewsArticle'
  ## Images and Videos
  has_many :user_images, dependent: :destroy
  has_many :user_videos, dependent: :destroy
  ## UserTopicSubscriptions
  has_many :user_topic_subscriptions, dependent: :destroy
  has_many :subscribed_news_categories, through: :user_topic_subscriptions, source: :source, source_type: 'NewsCategory'
  has_many :subscribed_topics, through: :user_topic_subscriptions, source: :source, source_type: 'Topic'
  # Suggested Topics
  has_many :suggested_topics, class_name: 'Topic', foreign_key: :suggester_id, dependent: :nullify
  # Languages
  has_and_belongs_to_many :languages
  
  # Fields validations
  validates :email, uniqueness: true, presence: true, length: { maximum: 100 }, format: { with: User::EMAIL_FORMAT }
  validates :password, presence: true, length: { minimum: 8 }, format: { with: User::PASSWORD_FORMAT, message: 'must contain at least eight characters and one number or symbol' }, if: -> { self.password.present? }
  validates :security_question_answer, presence: true
  validates :username, presence: true, uniqueness: true, format: { with: User::USERNAME_FORMAT, message: 'must contain from 6 to 18 characters, dots and underscores are allowed' }, if: -> { self.new_record? }
  validates :user_security_question_id, presence: true
  
  # Virtual attributes
  attr_writer :login
  
  # Normalization
  def email=(value)
    super(value&.downcase&.strip)
  end
  
  def first_name=(value)
    super(value&.strip)
  end
  
  def last_name=(value)
    super(value&.strip)
  end
  
  def username=(value)
    super(value&.downcase&.strip)
  end
  
  def is_group_subscription(group)
    case group.class.name
    when 'NewsCategory'
      self.subscribed_news_categories.include?(group)
    when 'Topic'
      self.subscribed_topics.include?(group)
    else
      false
    end
  end
  
  def group_subscription_counts(group)
    self.subscribed_news_categories.where(id: group.id).count + self.subscribed_topics.where(id: group.approved_nested_topics_ids).count
  end
  
  # Calculations
  def lits_count
    Lit.where(source_type: 'Comment', source_id: self.comments.ids).count
  end
  
  def comments_count
    self.comments.count
  end
  
  def views_count
    View.where(source_type: 'Post', source_id: self.posts.ids).count
  end
  
  def full_name
    if self.first_name.present? || self.last_name.present?
      "#{self.first_name} #{self.last_name}".strip
    else
      "#{self.username.capitalize}"
    end
  end
  
  def is_national_news?
    self.country.is_national_news && self.country.news_articles.present?
  end
  
  def is_world_news?
    self.country.is_national_news && self.country.languages.count > 0
  end
  
  # Show reconfirmed link if User doesn't confirm his email or confirmation token expired
  def can_be_reconfirmed?
    self.confirmation_period_expired? && !self.confirmed?
  end
  
  # Authenticate form email or username
  def login
    @login || self.username || self.email
  end
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
  
  def count_squad_members
    self.squad_requests_as_receiver.where.not(accepted_at: nil).or(self.squad_requests_as_requestor.where.not(accepted_at: nil)).distinct.count
  end
  
  def count_squad_requests
    # Count Squad requests for User as receiver
    self.squad_requests_as_receiver.where(accepted_at: nil, declined_at: nil).count
  end
   
  private
    def set_user_settings
      return if self.setting.present?
      Setting.get_setting(self)
    end
end
