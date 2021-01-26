class Schedule::TestJob < ApplicationJob
  
  def run
    puts "===== [TEST JOB]"
  end
end
