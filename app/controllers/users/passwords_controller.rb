class Users::PasswordsController < Devise::PasswordsController
  # Custom User lock for ForgotPassword
  skip_before_action :require_no_authentication, :only => [:new, :create]
  
  def create
    super
    
    # Lock User that have more than 3 secure question answer attempts
    user = User.find_by(username: resource.username)
    if user && resource.errors.present?
      user.increment_failed_attempts
      user.lock_access! if user.failed_attempts >= 3
    end
  end
end
