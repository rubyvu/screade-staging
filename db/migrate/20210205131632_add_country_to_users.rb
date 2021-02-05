class AddCountryToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :country_id, :integer, null: false
  end
  
  def down
    remove_column :users, :country_id
  end
end
