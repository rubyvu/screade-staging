# == Schema Information
#
# Table name: user_videos
#
#  id         :bigint           not null, primary key
#  is_private :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
class UserVideoSerializer < ActiveModel::Serializer
  
  attribute :file_thumbnail
  def file_thumbnail
    object.file_thumbnail_url
  end
  
  attribute :file_url
  def file_url
    object.file_url
  end
  
  attribute :id
  attribute :is_private
end
