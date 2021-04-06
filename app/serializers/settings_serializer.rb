class SettingsSerializer < ActiveModel::Serializer
  attribute :font_family
  attribute :font_style
  attribute :is_notification
  attribute :is_email
  attribute :is_images
  attribute :is_videos
  attribute :is_posts
end
