class AddHistoryClearedAtToChatMemberships < ActiveRecord::Migration[6.1]
  def up
    add_column :chat_memberships, :history_cleared_at, :datetime
  end
  
  def down
    remove_column :chat_memberships, :history_cleared_at
  end
end
