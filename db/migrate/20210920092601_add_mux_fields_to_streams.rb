class AddMuxFieldsToStreams < ActiveRecord::Migration[6.1]
  def change
    add_column :streams, :mux_stream_id, :string
    add_column :streams, :mux_stream_key, :string
    add_column :streams, :mux_playback_id, :string
  end
end
