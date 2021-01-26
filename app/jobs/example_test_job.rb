class ExampleTestJob < ApplicationJob
  
  def run(test_id)
    puts "===== [TEST JOB] #{test_id}"
  end
end
