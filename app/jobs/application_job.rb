class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked
  
  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
  
  # Start Que like:
  # bundle exec que -q schedule -q default
  
  # Get all Que jobs from DB
  # sql = "SELECT * from que_jobs"
  # result = ActiveRecord::Base.connection.execute(sql)
  # result.to_a
  
  # Clear all jobls from DB
  # Que.clear!
  
  # Get support for all of Que's helper methods
  include Que::ActiveJob::JobExtensions
end
