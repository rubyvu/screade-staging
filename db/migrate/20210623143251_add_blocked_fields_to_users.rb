class AddBlockedFieldsToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :blocked_at, :datetime
    add_column :users, :blocked_comment, :string
  end
  
  def down
    remove_column :users, :blocked_at
    remove_column :users, :blocked_comment
  end
end
