class IndexNewsArticlesOnCountryId < ActiveRecord::Migration[6.1]
  def change
    add_index :news_articles, :country_id
  end
end
