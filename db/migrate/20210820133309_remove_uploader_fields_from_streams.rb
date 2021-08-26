class RemoveUploaderFieldsFromStreams < ActiveRecord::Migration[6.1]
  def change
    remove_column :streams, :image
    remove_column :streams, :image_hex
    remove_column :streams, :video
    remove_column :streams, :video_hex
  end
end
