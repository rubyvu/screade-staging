# == Schema Information
#
# Table name: user_images
#
#  id         :bigint           not null, primary key
#  is_private :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
class UserImageSerializer < ActiveModel::Serializer
  
  attribute :id
  attribute :is_private
  attribute :rectangle_160_160_url
  def rectangle_160_160_url
    object.file_160_160_url
  end
  
  attribute :rectangle_1024_768_url
  def rectangle_1024_768_url
    object.file_1024_768_url
  end
end
