class CreateUserAssetsJob < ApplicationJob
  
  def run(type, asset_uploader_id, key)
    asset_uploader = nil
    if type == 'UserImage'
      asset_uploader = UserImage.find_by(id: asset_uploader_id)
    elsif type == 'UserVideo'
      asset_uploader = UserVideo.find_by(id: asset_uploader_id)
    end
    
    return if asset_uploader.blank?
    
    asset_uploader.file_key = key
    asset_uploader.remote_file_url = Tasks::AwsS3Api.get_presigned_url(asset_uploader.file_key)
    if asset_uploader.save
      puts "[SUCCESS]: #{asset_uploader.class.name} with id #{asset_uploader.id} successfuly updated"
    else
      puts "[ERROR]: #{asset_uploader.class.name} with id #{asset_uploader.id} cannot be updated [#{asset_uploader.errors.full_messages}]"
    end
  end
end
