class ChangeIndexForLitsAndViews < ActiveRecord::Migration[6.1]
  def change
    remove_index :lits, [:source_id, :source_type]
    remove_index :views, [:source_id, :source_type]
    
    add_index :lits, [:source_id, :source_type, :user_id], unique: true
    add_index :views, [:source_id, :source_type, :user_id], unique: true
  end
end
