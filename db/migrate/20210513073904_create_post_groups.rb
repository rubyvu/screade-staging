class CreatePostGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :post_groups do |t|
      t.integer :group_id, null: false
      t.string :group_type, null: false
      t.integer :post_id, null: false
      t.timestamps
      t.index :post_id
    end
  end
end
