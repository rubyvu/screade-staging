class CreateUserAssets < ActiveRecord::Migration[6.1]
  def change
    create_table :user_assets do |t|
      t.string :asset
      t.string :asset_hex
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
