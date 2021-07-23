class AddIsMuteToChatMemberships < ActiveRecord::Migration[6.1]
  def up
    add_column :chat_memberships, :is_mute, :boolean, null: false, default: false
  end
  
  def down
    remove_column :chat_memberships, :is_mute
  end
end
