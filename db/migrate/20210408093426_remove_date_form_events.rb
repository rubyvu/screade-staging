class RemoveDateFormEvents < ActiveRecord::Migration[6.1]
  def up
    remove_column :events, :date
  end
  
  def down
    add_column :events, :date, :date, null: true
  end
end
