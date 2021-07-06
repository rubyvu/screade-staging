class ChangeBreakingNews < ActiveRecord::Migration[6.1]
  def change
    add_column :breaking_news, :post_id, :integer
    remove_column :breaking_news, :title
    remove_column :breaking_news, :is_active
  end
end
