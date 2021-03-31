class AddCountersToComments < ActiveRecord::Migration[6.1]
  def up
    add_column :comments, :lits_count, :integer, default: 0, null: false
  end
  
  def down
    remove_column :comments, :lits_count
  end
end
