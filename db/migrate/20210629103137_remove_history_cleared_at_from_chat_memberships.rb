class RemoveHistoryClearedAtFromChatMemberships < ActiveRecord::Migration[6.1]
  def up
    remove_column :chat_memberships, :history_cleared_at
  end
  
  def down
    add_column :chat_memberships, :history_cleared_at, :datetime
  end
end
