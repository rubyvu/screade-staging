class StartInProgressTrackerJob < ApplicationJob
  # Check that client stream video by viewing :in_progress_at field
  
  def run(stream_id)
    stream = Stream.find_by(id: stream_id)
    return if stream.blank? || stream.status != 'in-progress'
    
    if stream.in_progress_at && stream.in_progress_at <= 1.minute.ago
      stream.update(status: 'completed')
    else
      StartInProgressTrackerJob.perform_later(stream.id)
    end
  end
end
