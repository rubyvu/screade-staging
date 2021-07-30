class Setting < ApplicationRecord
  # Constants
  FONT_FAMILIES = ['roboto', 'vivaldi', 'times-new-roman', 'broadway']
  FONT_STYLE = ['normal', 'bold', 'italic']
  
  # Association
  belongs_to :user
  
  # Association validation
  validates :user, presence: true, uniqueness: true
  
  # Validations
  validates :font_family, presence: true, inclusion: { in: Setting::FONT_FAMILIES }
  validates :font_style, presence: true, inclusion: { in: Setting::FONT_STYLE }
  validates :is_current_location, inclusion: { in: [true, false] }
  validates :is_email, inclusion: { in: [true, false] }
  validates :is_images, inclusion: { in: [true, false] }
  validates :is_notification, inclusion: { in: [true, false] }
  validates :is_posts, inclusion: { in: [true, false] }
  validates :is_videos, inclusion: { in: [true, false] }
  
  def self.get_setting(user)
    setting = Setting.find_by(user: user)
    if setting.nil?
      params = {
        font_family: 'roboto',
        font_style: 'normal',
        is_current_location: false,
        is_notification: true,
        is_email: true,
        is_images: true,
        is_videos: true,
        is_posts: true,
        user_id: user.id
      }
      setting = Setting.create(params)
    end
    return setting
  end
end
