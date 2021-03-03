class UserAssetsController < ApplicationController
  
  def new
    @uploader = UserAsset.new.image
    @uploader.success_action_redirect = new_user_url
  end
  
end
