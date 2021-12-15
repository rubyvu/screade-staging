class CreateUserBlocks < ActiveRecord::Migration[6.1]
  def change
    create_table :user_blocks do |t|
      t.bigint :blocker_user_id, null: false
      t.bigint :blocked_user_id, null: false
      t.timestamps
      
      t.index [:blocker_user_id, :blocked_user_id], unique: true
    end
  end
end
