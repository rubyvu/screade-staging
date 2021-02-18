class UpdateRequiredFieldsForUsers < ActiveRecord::Migration[6.1]
  def up
    change_column :users, :first_name, :string, null: true
    change_column :users, :last_name, :string, null: true
    add_column :users, :middle_name, :string
  end
  
  def down
    change_column :users, :first_name, :string, null: false
    change_column :users, :last_name, :string, null: false
    remove_column :users, :middle_name
  end
end
