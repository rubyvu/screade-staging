class Schedule::GetNewsArticlesJob < ApplicationJob
  
  def run
    puts "=== run GetNewsArticlesJob === #{DateTime.now}"
    return if Rails.env.development?
    puts "Update News Articles ..."
    
    Country.where(code: Country::COUNTRIES_WITH_NATIONAL_NEWS).each do |country|
      puts "Download news for #{country.title}"
      Tasks::NewsApi.get_articles(country.code)
    end
  end
end
