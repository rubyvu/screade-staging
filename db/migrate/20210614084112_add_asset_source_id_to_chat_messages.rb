class AddAssetSourceIdToChatMessages < ActiveRecord::Migration[6.1]
  def up
    add_column :chat_messages, :asset_source_id, :integer
    add_column :chat_messages, :asset_source_type, :string
  end
  
  def down
    remove_column :chat_messages, :asset_source_id
    remove_column :chat_messages, :asset_source_type
  end
end
