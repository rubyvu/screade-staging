class CreateJoinTableStreamNewsCategory < ActiveRecord::Migration[6.1]
  def change
    create_join_table :streams, :news_categories do |t|
      t.index [:stream_id, :news_category_id], unique: true
    end
  end
end
