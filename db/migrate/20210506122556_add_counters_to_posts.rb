class AddCountersToPosts < ActiveRecord::Migration[6.1]
  def up
    add_column :posts, :comments_count, :integer, default: 0, null: false
    add_column :posts, :lits_count, :integer, default: 0, null: false
    add_column :posts, :views_count, :integer, default: 0, null: false
  end
  
  def down
    remove_column :posts, :comments_count
    remove_column :posts, :lits_count
    remove_column :posts, :views_count
  end
end
