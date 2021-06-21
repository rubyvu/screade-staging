class AddAccessTokenToChats < ActiveRecord::Migration[6.1]
  def up
    add_column :chats, :access_token, :string, null: false
    add_index :chats, :access_token, unique: true
  end
  
  def down
    remove_column :chats, :access_token
  end
end
