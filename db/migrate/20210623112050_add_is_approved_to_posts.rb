class AddIsApprovedToPosts < ActiveRecord::Migration[6.1]
  def up
    add_column :posts, :is_approved, :boolean, default: true
    remove_column :posts, :state
  end
  
  def down
    remove_column :posts, :is_approved
    add_column :posts, :state, :string, null: false, default: 'pending'
  end
end
