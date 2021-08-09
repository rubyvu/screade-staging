class StartStreamChannelsJob < ApplicationJob
  
  def run(stream_id)
    stream = Stream.find_by(id: stream_id)
    return if stream.blank?
      
    if stream.channel_id.blank?
      stream.update(status: 'failed', error_message: 'Channel ID became empty')
      return
    end
    
    channel_status = ''
    begin
      channel_status = Tasks::AwsMediaLiveApi.channel_start(stream.channel_id).successful[0].state
    end
    
    case channel_status
    when 'STARTING'
      StartStreamStatusJob.set(wait: 10.seconds).perform_later(stream_id)
    when 'RUNNING'
      return
    else
      stream.update(status: 'failed', error_message: 'Starting request faild.')
    end
  end
end
