class CreateNewsArticlesJob < ApplicationJob
  
  def run(country_code, category_title)
    Tasks::NewsApi.create_articles(country_code, category_title)
  end
end
