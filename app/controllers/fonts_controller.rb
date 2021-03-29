class FontsController < ApplicationController
  
  # GET /fonts/customize
  def customize
    @setting = current_user.setting
  end
end
