class AddUnreadMessagesCounteToChatMemberships < ActiveRecord::Migration[6.1]
  def up
    add_column :chat_memberships, :unread_messages_count, :integer, null: false, default: 0
  end
  
  def down
    remove_column :chat_memberships, :unread_messages_count
  end
end
