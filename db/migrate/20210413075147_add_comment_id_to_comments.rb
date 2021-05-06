class AddCommentIdToComments < ActiveRecord::Migration[6.1]
  def up
    add_column :comments, :comment_id, :integer
  end
  
  def down
    remove_column :comments, :comment_id
  end
end
