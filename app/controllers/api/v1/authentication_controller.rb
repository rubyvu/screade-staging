class Api::V1::AuthenticationController < Api::V1::ApiController
  skip_before_action :authenticate, only: [:sign_in, :sign_up]
  
  # POST /api/v1/authentication/sign_in
  def sign_in
    email = user_params[:email]
    if email.blank?
      render json: { errors: ['Email is required'] }, status: :bad_request
      return
    end
    
    password = user_params[:password]
    if password.blank?
      render json: { errors: ['Password is required'] }, status: :bad_request
      return
    end
    
    user = User.find_by!(email: email.downcase)
    unless user.valid_password?(password)
      render json: { errors: ["User with this email doesn't exist or password is wrong"] }, status: :not_found
      return
    end
    
    device = Device.new(device_params)
    device.owner = user
    
    # Create Device
    unless device.save
      render json: { errors: device.errors.full_messages }, status: :bad_request
      return
    end
    
    user_json = UserSerializer.new(user).attributes.as_json
    render json: { access_token: device.access_token, user: user_json }, status: :ok
  end
  
  # POST /api/v1/authentication/sign_up
  def sign_up
    # Check User params
    user = User.new(user_params)
    unless user.valid?
      render json: { errors: user.errors.full_messages }, status: :bad_request
      return
    end
    
    # Check Device params
    device = Device.new(device_params)
    device.owner = user
    unless device.valid?
      render json: { errors: device.errors.full_messages }, status: :bad_request
      return
    end
    
    # Save new User and Device
    user.save
    device.save
    
    user_json = UserSerializer.new(user).attributes.as_json
    render json: { user: user_json }, status: :created
  end
  
  # DELETE /api/v1/authentication/sign_out
  def sign_out
    current_device.destroy
    render json: { success: true }, status: :ok
  end
  
  private
    def device_params
      params.require(:device).permit(:name, :operational_system)
    end
    
    def user_params
      params.require(:user).permit(:birthday, :email, :first_name, :last_name, :password, :password_confirmation, :phone_number, :profile_picture)
    end
end
