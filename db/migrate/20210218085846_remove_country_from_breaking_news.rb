class RemoveCountryFromBreakingNews < ActiveRecord::Migration[6.1]
  def up
    remove_column :breaking_news, :country_id
  end
  
  def down
    add_column :breaking_news, :country_id, :integer, null: false
    add_index :breaking_news, :country_id
  end
end
