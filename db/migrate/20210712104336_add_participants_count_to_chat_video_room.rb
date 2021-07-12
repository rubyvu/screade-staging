class AddParticipantsCountToChatVideoRoom < ActiveRecord::Migration[6.1]
  def up
    add_column :chat_video_rooms, :participants_count, :integer, null: false, default: 0
  end
  
  def down
    remove_column :chat_video_rooms, :participants_count
  end
end
