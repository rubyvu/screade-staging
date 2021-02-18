class CurrentUserController < ApplicationController
  
  # PUT/PATCH /current_user
  def update
    current_user.update(user_params)
    redirect_to root_path
  end
  
  private
    def user_params
      params.require(:user).permit(:banner_picture, :birthday, :country_code, :email, :first_name, :last_name, :middle_name, :phone_number, :profile_picture)
    end
end
