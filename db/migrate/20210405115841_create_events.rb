class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.date :date, null: false
      t.datetime :start_time, null: false
      t.datetime :end_date, null: false
      t.string :title, null: false
      t.text :description
      t.integer :user_id, null: false
      t.timestamps
      t.index :user_id
    end
  end
end
