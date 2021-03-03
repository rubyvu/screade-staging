class Setting < ApplicationRecord
  # Constants
  FONT_FAMILIES = %w(Roboto)
  FONT_STYLE = %w(normal)
  
  # Association validation
  belongs_to :user
  
  # Validations
  validates :font_family, presence: true, inclusion: { in: Setting::FONT_FAMILIES }
  validates :font_style, presence: true, inclusion: { in: Setting::FONT_STYLE }
  validates :is_images, presence: true
  validates :is_notification, presence: true
  validates :is_posts, presence: true
  validates :is_videos, presence: true
  
  def self.font_family
    get_settings().font_family
  end
  
  def self.font_style
    get_settings().font_style
  end
  
  def self.is_images
    get_settings().is_images
  end
  
  def self.is_notification
    get_settings().is_notification
  end
  
  def self.is_videos
    get_settings().is_videos
  end
  
  def self.is_posts
    get_settings().is_posts
  end
  
  def self.get_settings
    settings = Setting.first
    if settings.nil?
      params = {
        font_family: 'Roboto'
        font_style: 'normal',
        is_notification: true,
        is_images: true,
        is_videos: true,
        is_posts: true
      }
      settings = Setting.create(params)
    end
    return settings
  end
end
