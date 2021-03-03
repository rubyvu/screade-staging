class UserAsset < ApplicationRecord
   mount_uploader :asset, UserImageUploader
   
   # Assosiation
   belongs_to :user
end
