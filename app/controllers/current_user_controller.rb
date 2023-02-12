class CurrentUserController < ApplicationController

  # PUT/PATCH /current_user
  def update
    # Skip profile_picture & profile_picture_base64 if there is cropped version coming in (profile_picture_base64)
    profile_picture_base64 = user_params[:profile_picture_base64]
    unless profile_picture_base64.blank?
      user_params.delete(:profile_picture)
      user_params.delete(:profile_picture_base64)
    end

    current_user.update(user_params)

    # Attach cropped Base64 profile_picture
    unless profile_picture_base64.blank?
      decoded_image = Base64.decode64(profile_picture_base64.split(',')[1])
      current_user.profile_picture.attach(
        io: StringIO.new(decoded_image),
        content_type: 'image/jpeg', # cropperjs makes it image/jpeg
        filename: 'image.jpg'
      )
    end

    if params[:edit_profile].present?
      redirect_to user_path(username: current_user.username)
    else
      redirect_to download_apps_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:allow_direct_messages, :banner_picture, :birthday, :country_id, :email, :first_name, :last_name, :middle_name, :phone_number, :profile_picture, :profile_picture_base64, language_ids: [])
  end
end
