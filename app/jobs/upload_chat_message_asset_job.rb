class UploadChatMessageAssetJob < ApplicationJob
  
  def run(chat_message_id)
    chat_message = ChatMessage.find_by(id: chat_message_id)
    return if chat_message.blank? || chat_message.asset_source.blank?
    
    chat_message.remote_image_url = chat_message.asset_source.file.url
    chat_message.save(validate: false)
  end
end
