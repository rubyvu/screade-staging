class UserAssetsController < ApplicationController
  
  def new
    @uploader = UserAsset.new.asset
    @uploader.success_action_redirect = webhook_user_assets_url
    @uploader.policy(enforce_utf8: false)
  end
  
  def webhook
    puts "-----"
    new_asset = UserAsset.create(user: User.find_by(username: 'xyz'))
    new_asset.asset_key = params[:key]
    new_asset.remote_asset_url = new_asset.asset.direct_fog_url() + new_asset.asset_key
    puts "===== #{new_asset.remote_asset_url}"
    new_asset.save!
  end
end
