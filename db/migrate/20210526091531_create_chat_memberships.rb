class CreateChatMemberships < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_memberships do |t|
      t.integer :chat_id, null: false
      t.integer :user_id, null: false
      t.string :role, null: false, default: 'user'
      t.timestamps
      t.index :chat_id
      t.index :user_id
    end
  end
end
