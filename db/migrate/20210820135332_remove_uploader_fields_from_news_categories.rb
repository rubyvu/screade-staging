class RemoveUploaderFieldsFromNewsCategories < ActiveRecord::Migration[6.1]
  def change
    remove_column :news_categories, :image
  end
end
