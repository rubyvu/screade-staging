class Users::SessionsController < Devise::SessionsController
  respond_to :html, :js
  # Remove layout for xhr request
  before_action proc { |controller| (controller.action_has_layout = false) if controller.request.xhr? }
end
