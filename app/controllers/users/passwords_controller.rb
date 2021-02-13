class Users::PasswordsController < Devise::PasswordsController
  # Custom User lock for ForgotPassword
  skip_before_action :require_no_authentication, :only => [:new, :create]
  
  respond_to :html, :js
  # Remove layout for xhr request
  before_action proc { |controller| (controller.action_has_layout = false) if controller.request.xhr? }
  
  def create
    super
    
    # Lock User that have more than 3 secure question answer attempts
    user = User.find_by(email: resource.email)
    if user && resource.errors.present?
      user.increment_failed_attempts
      user.lock_access! if user.failed_attempts >= 3
    end
  end
end
