class UserImagesController < ApplicationController
  
  def new
    @image_uploader = UserImage.new.file
    @image_uploader.success_action_redirect = webhook_user_images_url
    @image_uploader.policy(enforce_utf8: false)
  end
  
  def webhook
    new_user_image = UserImage.create(user: User.find_by(username: 'xyz'))
    new_user_image.file_key = params[:key]
    new_user_image.remote_file_url = Tasks::AwsS3Api.get_presigned_url(new_user_image.file_key)
    new_user_image.save!
  end
end
