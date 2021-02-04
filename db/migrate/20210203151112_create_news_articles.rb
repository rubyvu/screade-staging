class CreateNewsArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :news_articles do |t|
      t.integer :country_id, null: false
      t.integer :news_category_id, null: false
      t.datetime :published_at, null: false
      t.string :author
      t.string :title, null: false
      t.text :description
      t.string :url, null: false
      t.string :img_url
      t.timestamps
      t.index :url, unique: true
    end
  end
end
