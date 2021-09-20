class RemoveAwsFieldsFromStreams < ActiveRecord::Migration[6.1]
  def change
    remove_column :streams, :channel_id
    remove_column :streams, :channel_input_id
    remove_column :streams, :channel_security_group_id
    remove_column :streams, :rtmp_url
    remove_column :streams, :stream_url
  end
end
