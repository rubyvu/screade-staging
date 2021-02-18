class AddColumnIsNationalNewsToCountries < ActiveRecord::Migration[6.1]
  def up
    add_column :countries, :is_national_news, :boolean, default: false
  end
  
  def down
    remove_column :countries, :is_national_news
  end
end
