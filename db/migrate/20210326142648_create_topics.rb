class CreateTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :topics do |t|
      t.integer :parent_id, null: false
      t.string :parent_type, null: false
      t.string :title, null: false
      t.boolean :is_approved, default: false
      t.integer :nesting_position, null: false
      t.timestamps
      t.index :parent_id
    end
  end
end
