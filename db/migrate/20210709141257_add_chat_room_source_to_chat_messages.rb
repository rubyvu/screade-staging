class AddChatRoomSourceToChatMessages < ActiveRecord::Migration[6.1]
  def up
    add_column :chat_messages, :chat_room_source_id, :integer
    add_column :chat_messages, :chat_room_source_type, :string
  end
  
  def down
    remove_column :chat_messages, :chat_room_source_id
    remove_column :chat_messages, :chat_room_source_type
  end
end
