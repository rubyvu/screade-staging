class CreateChatMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_messages do |t|
      t.integer :chat_id, null: false
      t.integer :user_id, null: false
      t.string :message_type, null: false
      t.string :text
      t.string :image
      t.string :image_hex
      t.string :video
      t.string :video_hex
      t.string :audio_record
      t.string :audio_record_hex
      t.timestamps
      t.index :user_id
      t.index :chat_id
      t.index :message_type
    end
  end
end
