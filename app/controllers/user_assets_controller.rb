class UserAssetsController < ApplicationController
  
  def new
    @uploader = UserAsset.new.asset
    @uploader.success_action_redirect = root_url
    @uploader.policy(enforce_utf8: false)
  end
  
  def create
    
  end
end
