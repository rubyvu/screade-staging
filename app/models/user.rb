# == Schema Information
#
# Table name: users
#
#  id                        :bigint           not null, primary key
#  allow_direct_messages     :boolean          default(TRUE)
#  birthday                  :date
#  blocked_at                :datetime
#  blocked_comment           :string
#  confirmation_sent_at      :datetime
#  confirmation_token        :string
#  confirmed_at              :datetime
#  email                     :string           default(""), not null
#  encrypted_password        :string           default(""), not null
#  failed_attempts           :integer          default(0), not null
#  first_name                :string
#  hide_invitation_popup     :boolean          default(FALSE)
#  last_name                 :string
#  locked_at                 :datetime
#  middle_name               :string
#  phone_number              :string
#  remember_created_at       :datetime
#  reset_password_sent_at    :datetime
#  reset_password_token      :string
#  security_question_answer  :string           not null
#  unconfirmed_email         :string
#  username                  :string           not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  country_id                :integer          not null
#  invited_by_user_id        :bigint
#  user_security_question_id :integer          not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable, :trackable and :omniauthable
  devise :confirmable, :database_authenticatable, :lockable, :registerable, :recoverable, :validatable, authentication_keys: [:login]
  
  # Search
  searchkick searchable: [:username, :first_name, :last_name], match: :word_middle
  
  # Constants
  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  PASSWORD_FORMAT = /\A(?=.*[^a-zA-Z])/i  # Must contain at least one number or symbol
  USERNAME_FORMAT = /\A[a-zA-Z0-9](_(?!(\.|_))|\.(?!(_|\.))|[a-zA-Z0-9]){4,16}[a-zA-Z0-9]/i  #  Can contain characters from 6 to 18 symbols, allowed _(underscore) and .(dot) symbols
  USERNAME_ROUTE_FORMAT = /[^\/]+/  # Alow .(dot) in username for URL
  
  # File Uploader
  has_one_attached :profile_picture
  has_one_attached :banner_picture
  
  # Callbacks
  after_commit :set_user_settings, on: [:create]
  before_validation :block_user
  
  # Associations
  belongs_to :country
  belongs_to :user_security_question
  has_one :setting, dependent: :destroy
  has_one :user_location, dependent: :destroy
  has_many :chat_memberships, dependent: :destroy
  has_many :own_chats, class_name: 'Chat', foreign_key: :owner_id, dependent: :destroy
  has_many :chat_messages, dependent: :destroy
  has_many :devices, class_name: 'Device', foreign_key: 'owner_id', dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :post_groups, through: :posts
  has_many :received_notifications, class_name: 'Notification', foreign_key: :recipient_id, dependent: :destroy
  ## Streams
  has_many :user_streams, class_name: 'Stream', foreign_key: 'user_id', dependent: :destroy
  ## Squad requests
  has_many :squad_requests_as_receiver, foreign_key: :receiver_id, class_name: 'SquadRequest', dependent: :destroy
  has_many :squad_requests_as_requestor, foreign_key: :requestor_id, class_name: 'SquadRequest', dependent: :destroy
  ## Comments
  has_many :comments, dependent: :destroy
  has_many :commented_news_articles, through: :comments, source: :source, source_type: 'NewsArticle'
  ## Invitations
  has_many :invitations, foreign_key: :invited_by_user_id, class_name: 'Invitation', dependent: :destroy
  belongs_to :invited_by_user, foreign_key: :invited_by_user_id, class_name: 'User', optional: true
  ## Lits
  has_many :lits, dependent: :destroy
  has_many :lited_news_articles, through: :lits, source: :source, source_type: 'NewsArticle'
  ## reports
  has_many :reports_as_reported, foreign_key: :reported_user_id, class_name: 'Report', dependent: :nullify
  has_many :reports_as_reporter, foreign_key: :reporter_user_id, class_name: 'Report', dependent: :nullify
  ## Views
  has_many :views, dependent: :destroy
  has_many :viewed_news_articles, through: :views, source: :source, source_type: 'NewsArticle'
  ## UserBlocks
  has_many :user_blocks_as_blocked, foreign_key: :blocked_user_id, class_name: 'UserBlock', dependent: :destroy
  has_many :user_blocks_as_blocker, foreign_key: :blocker_user_id, class_name: 'UserBlock', dependent: :destroy
  ## Images and Videos
  has_many :user_images, dependent: :destroy
  has_many :user_videos, dependent: :destroy
  ## UserTopicSubscriptions
  has_many :user_topic_subscriptions, dependent: :destroy
  has_many :subscribed_news_categories, through: :user_topic_subscriptions, source: :source, source_type: 'NewsCategory'
  has_many :subscribed_topics, through: :user_topic_subscriptions, source: :source, source_type: 'Topic'
  # Suggested Topics
  has_many :suggested_topics, foreign_key: :suggester_id, class_name: 'Topic', dependent: :nullify
  has_many :sent_shared_records, foreign_key: :sender_id, class_name: 'SharedRecord', dependent: :destroy
  # Languages
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :streams
  
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
  
  def profile_picture_url
    self.profile_picture.representation(resize_to_limit: [320, 320]).processed.url if self.profile_picture.attached?
  end
  
  def banner_picture_url
    self.banner_picture.representation(resize_to_limit: [300, 250]).processed.url if self.banner_picture.attached?
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
  
  # Blocked User by Devise
  def active_for_authentication?
    super && self.blocked_at.blank?
  end
  
  def inactive_message
    "This account has been blocked by Admin."
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
    
    def block_user
      return if self.blocked_at.present? && self.blocked_comment.present?
      
      if self.blocked_comment.blank?
        self.blocked_at = nil
      else
        self.blocked_at = DateTime.current
        
        # Remove API sessions
        self.devices.destroy_all
      end
    end
end
