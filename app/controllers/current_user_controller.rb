class CurrentUserController < ApplicationController
  
  # PUT/PATCH /current_user
  def update
    current_user.update(user_params)
    if params[:edit_profile].present?
      redirect_to user_path(username: current_user.username)
    else
      redirect_to root_path
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:banner_picture, :birthday, :country_code, :email, :first_name, :last_name, :middle_name, :phone_number, :profile_picture, language_ids: [])
    end
end
