class AddAllowDirectMessagesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :allow_direct_messages, :boolean, default: true
  end
end
