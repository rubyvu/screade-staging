class StartStreamStatusJob < ApplicationJob
  
  def run(stream_id)
    stream = Stream.find_by(id: stream_id)
    return if stream.blank? || stream.status != 'pending'
    
    stream_start_status = Tasks::AwsMediaLiveApi.channel_status(stream.channel_id)
    case stream_start_status
    when 'RUNNING'
      stream.update(status: 'in-progress')
    when 'STARTING'
      StartStreamStatusJob.set(wait: 10.seconds).perform_later(stream_id)
    else
      stream.update(status: 'failed', error_message: 'Stream cannot be started')
    end
  end
end
