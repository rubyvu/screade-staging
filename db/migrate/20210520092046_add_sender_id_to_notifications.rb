class AddSenderIdToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :sender_id, :integer
  end
end
