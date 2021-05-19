class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :user_id, null: false
      t.integer :source_id, null: false
      t.string :source_type, null: false
      t.boolean :is_viewed, default: false
      t.string :message, null: false
      t.timestamps
      t.index :user_id
    end
  end
end
