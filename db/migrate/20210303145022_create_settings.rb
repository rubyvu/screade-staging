class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings do |t|
      t.string :font_family
      t.string :font_style
      t.boolean :is_notification, default: true
      t.boolean :is_images, default: true
      t.boolean :is_videos, default: true
      t.boolean :is_posts, default: true
      t.integer :user_id, null: false
      t.index :user_id
    end
  end
end
