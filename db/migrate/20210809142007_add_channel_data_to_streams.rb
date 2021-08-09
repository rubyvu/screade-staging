class AddChannelDataToStreams < ActiveRecord::Migration[6.1]
  def up
    add_column :streams, :channel_id, :string
    add_column :streams, :channel_input_id, :string
  end
  
  def down
    remove_column :streams, :channel_id
    remove_column :streams, :channel_input_id
  end
end
