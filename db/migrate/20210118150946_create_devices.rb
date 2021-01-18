class CreateDevices < ActiveRecord::Migration[6.1]
  def change
    create_table :devices do |t|
      t.string :access_token, null: false
      t.integer :owner_id, null: false
      t.string :name
      t.string :operational_system, null: false
      t.timestamps
      t.index :access_token, unique: true
      t.index :owner_id
    end
  end
end
