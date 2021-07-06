class ChangeDescriptionForPosts < ActiveRecord::Migration[6.1]
  def up
    change_column :posts, :description, :text, null: false
  end
  
  def down
    change_column :posts, :description, :string, null: false
  end
end
