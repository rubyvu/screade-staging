# == Schema Information
#
# Table name: settings
#
#  id                        :bigint           not null, primary key
#  font_family               :string
#  font_style                :string
#  is_current_location       :boolean          default(FALSE), not null
#  is_email                  :boolean
#  is_images                 :boolean          default(TRUE)
#  is_notification           :boolean          default(TRUE)
#  is_posts                  :boolean          default(TRUE)
#  is_videos                 :boolean          default(TRUE)
#  sign_in_redirect_location :string           default("Home"), not null
#  user_id                   :integer          not null
#
# Indexes
#
#  index_settings_on_user_id  (user_id)
#
class Setting < ApplicationRecord
  # Constants
  FONT_FAMILIES = ['roboto', 'vivaldi', 'times-new-roman', 'broadway']
  FONT_STYLE = ['normal', 'bold', 'italic']
  REDIRECT_LOCATIONS = ['Home', 'Profile']
  
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
  validates :sign_in_redirect_location, presence: true, inclusion: { in: Setting::REDIRECT_LOCATIONS }
  
  def self.get_setting(user)
    setting = Setting.find_by(user: user)
    unless setting
      params = {
        font_family: 'roboto',
        font_style: 'normal',
        is_current_location: false,
        is_email: true,
        is_images: true,
        is_notification: true,
        is_posts: true,
        is_videos: true,
        sign_in_redirect_location: 'Home',
        user_id: user.id
      }
      setting = Setting.create(params)
    end
    return setting
  end
end
