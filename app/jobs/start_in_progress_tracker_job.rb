class StartInProgressTrackerJob < ApplicationJob
  # Check that client stream video by viewing :in_progress_at field
  
  def run(stream_id)
    puts "========== In progress updated #{stream_id}"
    stream = Stream.find_by(id: stream_id)
    return if stream.blank? || stream.status != 'in-progress'
    
    puts "====== #{stream.in_progress_at <= 1.minute.ago}"
    if stream.in_progress_at && stream.in_progress_at <= 1.minute.ago
      puts "=== End"
      stream.update(status: 'completed')
    else
      puts "=== Refresh"
      StartInProgressTrackerJob.set(wait: 1.minute).perform_later(stream.id)
    end
  end
end
