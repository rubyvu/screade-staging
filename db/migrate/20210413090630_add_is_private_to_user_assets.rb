class AddIsPrivateToUserAssets < ActiveRecord::Migration[6.1]
  def up
    add_column :user_images, :is_private, :boolean, default: true
    add_column :user_videos, :is_private, :boolean, default: true
  end
  
  def down
    remove_column :user_images, :is_private
    remove_column :user_videos, :is_private
  end
end
