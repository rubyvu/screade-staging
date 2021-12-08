class CreateSharedRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :shared_records do |t|
      t.bigint :sender_id, null: false
      t.bigint :shareable_id, null: false
      t.string :shareable_type, null: false
      t.timestamps
      
      t.index [:shareable_id, :shareable_type]
    end
  end
end
