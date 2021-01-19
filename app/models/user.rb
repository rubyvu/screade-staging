class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable
  
  # Constants
  EMAIL_FORMAT = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  
  # File Uploader
  mount_uploader :profile_picture, AvatarUploader
  mount_uploader :banner_picture, BannerUploader
  
  # Associations
  has_many :devices, class_name: 'Device', foreign_key: 'owner_id', dependent: :destroy
  
  # Fields validations
  validates :email, uniqueness: true, presence: true, length: { maximum: 100 }, format: { with: User::EMAIL_FORMAT }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :password, presence: true
  
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
