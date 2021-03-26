class AddImageToNewsCategory < ActiveRecord::Migration[6.1]
  def up
    add_column :news_categories, :image, :string
  end
  
  def down
    remove_column :news_categories, :image, :string
  end
end
