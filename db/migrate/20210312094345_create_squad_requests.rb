class CreateSquadRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :squad_requests do |t|
      t.integer :receiver_id
      t.integer :requestor_id
      t.datetime :accepted_at
      t.datetime :declined_at
      t.timestamps
      t.index [:receiver_id, :requestor_id]
    end
  end
end
