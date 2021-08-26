class RemoveUploaderFieldsFromChats < ActiveRecord::Migration[6.1]
  def change
    remove_column :chats, :icon
    remove_column :chats, :icon_hex
  end
end
