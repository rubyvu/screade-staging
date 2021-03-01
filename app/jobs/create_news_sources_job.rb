class CreateNewsSourcesJob < ApplicationJob
  
  def run
    Tasks::NewsApi.create_sources
  end
end
