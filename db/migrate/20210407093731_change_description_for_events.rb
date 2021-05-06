class ChangeDescriptionForEvents < ActiveRecord::Migration[6.1]
  def up
    change_column :events, :description, :text, null: false
  end
  
  def down
    change_column :events, :description, :text, null: true
  end
end
