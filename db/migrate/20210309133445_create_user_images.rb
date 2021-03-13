class CreateUserImages < ActiveRecord::Migration[6.1]
  def change
    create_table :user_images do |t|
      t.string :file
      t.string :file_hex
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
