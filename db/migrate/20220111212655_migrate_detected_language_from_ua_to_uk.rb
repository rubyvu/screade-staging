class MigrateDetectedLanguageFromUaToUk < ActiveRecord::Migration[6.1]
  def self.up
    NewsArticle.where(detected_language: 'UA').update_all(detected_language: 'UK')
  end
  
  def self.down
    NewsArticle.where(detected_language: 'UK').update_all(detected_language: 'UA')
  end
end
