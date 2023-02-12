
require 'rake'

class Schedule::GenerateSitemapJob < ApplicationJob
  Rails.application.load_tasks
  
  def run
    puts "=== run Schedule::GenerateSitemapJob === #{DateTime.current}"
    
    Rake::Task['sitemap:refresh'].invoke
  end
end
