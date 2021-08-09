class RemoveStreamGroupsTable < ActiveRecord::Migration[6.1]
  def change
    drop_join_table :streams, :news_categories
    drop_join_table :streams, :topics
  end
end
