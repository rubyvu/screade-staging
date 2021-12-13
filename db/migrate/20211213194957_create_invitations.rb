class CreateInvitations < ActiveRecord::Migration[6.1]
  def change
    create_table :invitations do |t|
      t.string :email, null: false
      t.string :token, null: false
      t.bigint :user_id
      t.bigint :invited_by_user_id, null: false
      t.timestamps
      
      t.index :user_id
      t.index :invited_by_user_id
    end
  end
end
