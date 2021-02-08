class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.text :message
      t.integer :user_id, null: false
      t.integer :source_id, null: false
      t.string :source_type, null: false
      t.timestamps
      t.index :source_id
    end
  end
end
