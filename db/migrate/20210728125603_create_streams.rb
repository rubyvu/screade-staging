class CreateStreams < ActiveRecord::Migration[6.1]
  def change
    create_table :streams do |t|
      t.string :title, null: false
      t.boolean :is_private, null: false, default: true
      t.integer :user_id, null: false
      t.string :image
      t.string :image_hex
      t.timestamps
      t.index :user_id
    end
  end
end
