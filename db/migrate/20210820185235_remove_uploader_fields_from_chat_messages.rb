class RemoveUploaderFieldsFromChatMessages < ActiveRecord::Migration[6.1]
  def change
    remove_column :chat_messages, :image
    remove_column :chat_messages, :image_hex
    remove_column :chat_messages, :video
    remove_column :chat_messages, :video_hex
    remove_column :chat_messages, :audio_record
    remove_column :chat_messages, :audio_record_hex
  end
end
