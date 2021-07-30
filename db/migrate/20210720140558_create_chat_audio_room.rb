class CreateChatAudioRoom < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_audio_rooms do |t|
      t.integer :chat_id, null: false
      t.string :sid, null: false
      t.string :status, null: false, default: 'in-progress'
      t.string :name, null: false
      t.integer :participants_count, null: false, default: 0
      t.timestamps
      t.index :chat_id
      t.index :name, unique: true
    end
  end
end
