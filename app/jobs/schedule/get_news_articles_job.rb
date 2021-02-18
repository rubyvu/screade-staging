class Schedule::GetNewsArticlesJob < ApplicationJob
  
  def run
    puts "=== run GetNewsArticlesJob === #{DateTime.now}"
    # return if Rails.env.development?
    return
    puts "Update News Articles ..."
    
    Country.all.each do |country|
      puts "Download news for #{country.title}"
      Tasks::NewsApi.get_articles(country.code)
    end
  end
end
