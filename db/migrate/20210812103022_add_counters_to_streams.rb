class AddCountersToStreams < ActiveRecord::Migration[6.1]
  def up
    add_column :streams, :stream_comments_count, :integer, default: 0, null: false
    add_column :streams, :views_count, :integer, default: 0, null: false
    add_column :streams, :lits_count, :integer, default: 0, null: false
  end
  
  def down
    remove_column :streams, :stream_comments_count
    remove_column :streams, :views_count
    remove_column :streams, :lits_count
  end
end
