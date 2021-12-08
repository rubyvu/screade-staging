class AddIsSharedToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :is_shared, :boolean, default: false
  end
end
