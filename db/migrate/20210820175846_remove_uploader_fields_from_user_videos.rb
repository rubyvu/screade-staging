class RemoveUploaderFieldsFromUserVideos < ActiveRecord::Migration[6.1]
  def change
    remove_column :user_videos, :file
    remove_column :user_videos, :file_hex
  end
end
