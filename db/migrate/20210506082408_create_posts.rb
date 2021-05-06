class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.integer :news_category_id, null: false
      t.integer :topic_id, null: false
      t.string :title, null: false
      t.string :description, null: false
      t.string :image
      t.string :image_hex
      t.boolean :is_notification, default: true
      t.string :state, default: 'pending', null: false
      t.timestamps
    end
  end
end
