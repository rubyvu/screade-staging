class AddPushTokenToDevices < ActiveRecord::Migration[6.1]
  def up
    add_column :devices, :push_token, :string
    add_index :devices, :push_token
  end
  
  def down
    remove_column :devices, :push_token
  end
end
