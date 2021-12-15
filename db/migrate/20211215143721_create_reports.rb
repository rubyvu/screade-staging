class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.bigint :reporter_user_id, null: false
      t.bigint :reported_user_id, null: false
      t.text :details, null: false
      t.timestamps
      
      t.index :reporter_user_id
      t.index :reported_user_id
    end
  end
end
