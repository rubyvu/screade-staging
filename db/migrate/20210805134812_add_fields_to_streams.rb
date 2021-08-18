class AddFieldsToStreams < ActiveRecord::Migration[6.1]
  def up
    add_column :streams, :access_token, :string, null: false
    add_column :streams, :error_message, :string
    add_column :streams, :status, :string, null: false, default: 'pending'
    add_index :streams, :status
    
    add_column :streams, :rtmp_url, :string
    add_column :streams, :stream_url, :string
    
    add_column :streams, :video, :string
    add_column :streams, :video_hex, :string
  end
  
  def down
    remove_column :streams, :access_token
    remove_column :streams, :error_message
    remove_column :streams, :rtmp_url
    remove_column :streams, :status
    remove_column :streams, :stream_url
    remove_column :streams, :video
    remove_column :streams, :video_hex
  end
end
