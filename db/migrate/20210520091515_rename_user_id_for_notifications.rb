class RenameUserIdForNotifications < ActiveRecord::Migration[6.1]
  def up
    rename_column :notifications, :user_id, :recipient_id
  end
  
  def down
    rename_column :notifications, :recipient_id, :user_id
  end
end
