class DeleteStreamChannelsJob < ApplicationJob
  
  def run(stream_id)
    stream = Stream.find_by(id: stream_id)
    return if stream.blank? || stream.channel_id.blank?
    
    begin
      channel_status = Tasks::AwsMediaLiveApi.channel_status(stream.channel_id)
    rescue
      channel_status = ''
    end
    
    case channel_status
    when 'IDLE'
      Tasks::AwsMediaLiveApi.delete_channel(stream.channel_id)
      Tasks::AwsMediaLiveApi.delete_input(stream.channel_input_id) if stream.channel_input_id.present?
    else
      DeleteStreamChannelsJob.set(wait: 15.seconds).perform_later(stream_id)
    end
  end
end
