class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable, :trackable and :omniauthable
  devise :confirmable, :database_authenticatable, :lockable, :registerable, :recoverable, :validatable
  
  # Constants
  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  
  # File Uploader
  mount_uploader :profile_picture, AvatarUploader
  mount_uploader :banner_picture, BannerUploader
  
  # Associations
  belongs_to :country
  belongs_to :user_security_question
  has_many :devices, class_name: 'Device', foreign_key: 'owner_id', dependent: :destroy
  # Lits
  has_many :lits
  has_many :lited_news_articles, through: :lits, source: :source, source_type: 'NewsArticle'
  
  # Fields validations
  validates :email, uniqueness: true, presence: true, length: { maximum: 100 }, format: { with: User::EMAIL_FORMAT }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, presence: true
  validates :security_question_answer, presence: true
  validates :username, presence: true, uniqueness: true
  validates :user_security_question_id, presence: true
  
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
  
  def full_name
    "#{first_name} #{last_name}".strip
  end
end
