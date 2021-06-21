class AddOwnerIdToChats < ActiveRecord::Migration[6.1]
  def change
    add_column :chats, :owner_id, :integer, null: false
    add_index :chats, :owner_id
  end
end
