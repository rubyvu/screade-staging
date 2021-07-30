class AddIsCurrentLocationToSettings < ActiveRecord::Migration[6.1]
  def up
    add_column :settings, :is_current_location, :boolean, null: false, default: false
  end
  
  def down
    remove_column :settings, :is_current_location
  end
end
