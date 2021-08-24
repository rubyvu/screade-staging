class UploadChatMessageAssetJob < ApplicationJob
  
  def run(chat_message_id)
    chat_message = ChatMessage.find_by(id: chat_message_id)
    return if chat_message.blank? || chat_message.asset_source.blank?
    
    source_file_url = chat_message.asset_source.file.url
    return if source_file_url.blank?
    
    chat_message_source = URI.parse(source_file_url).open
    if chat_message.asset_source_type == 'UserImage'
      chat_message.image.attach(io: chat_message_source, filename: SecureRandom.hex(16))
    elsif chat_message.asset_source_type == 'UserVideo'
      chat_message.video.attach(io: chat_message_source, filename: SecureRandom.hex(16))
    end
  end
end
