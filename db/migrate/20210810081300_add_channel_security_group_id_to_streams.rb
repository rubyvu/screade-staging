class AddChannelSecurityGroupIdToStreams < ActiveRecord::Migration[6.1]
  def up
    add_column :streams, :channel_security_group_id, :string
  end
  
  def down
    remove_column :streams, :channel_security_group_id, :string
  end
end
