class CreateNewsCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :news_categories do |t|
      t.string :title, null: false
      t.timestamps
      t.index :title, unique: true
    end
  end
end
