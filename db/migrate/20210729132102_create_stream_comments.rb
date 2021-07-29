class CreateStreamComments < ActiveRecord::Migration[6.1]
  def change
    create_table :stream_comments do |t|
      t.text :message
      t.integer :user_id
      t.integer :stream_id
      t.timestamps
      t.index :user_id
    end
  end
end
