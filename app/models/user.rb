class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable, :trackable and :omniauthable
  devise :confirmable, :database_authenticatable, :lockable, :registerable, :recoverable, :validatable, authentication_keys: [:login]
  
  # Constants
  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  PASSWORD_FORMAT = /\A(?=.*[^a-zA-Z])/x  # Must contain at least one number or symbol
  
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
  ## Squad requests
  has_many :squad_requests_as_receiver, foreign_key: :receiver_id, class_name: 'SquadRequest', dependent: :destroy
  has_many :squad_requests_as_requestor, foreign_key: :requestor_id, class_name: 'SquadRequest', dependent: :destroy
  ## Comments
  has_many :comments
  has_many :commented_news_articles, through: :comments, source: :source, source_type: 'NewsArticle'
  ## Lits
  has_many :lits
  has_many :lited_news_articles, through: :lits, source: :source, source_type: 'NewsArticle'
  ## Views
  has_many :views
  has_many :viewed_news_articles, through: :views, source: :source, source_type: 'NewsArticle'
  ## Images and Videos
  has_many :user_images, dependent: :destroy
  has_many :user_videos, dependent: :destroy
  # Languages
  has_and_belongs_to_many :languages
  
  # Fields validations
  validates :email, uniqueness: true, presence: true, length: { maximum: 100 }, format: { with: User::EMAIL_FORMAT }
  validates :password, presence: true, length: { minimum: 8 }, format: { with: PASSWORD_FORMAT, message: 'must contain at least eight characters and one number or symbol' }, if: -> { self.password.present? }
  validates :security_question_answer, presence: true
  validates :username, presence: true, uniqueness: true
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
  
  def full_name
    "#{first_name} #{last_name}".strip
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
   
  private
    def set_user_settings
      return if self.setting.present?
      Setting.get_setting(self)
    end
end
