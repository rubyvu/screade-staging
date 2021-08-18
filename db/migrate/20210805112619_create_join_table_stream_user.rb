class CreateJoinTableStreamUser < ActiveRecord::Migration[6.1]
  def change
    create_join_table :streams, :users do |t|
      t.index [:stream_id, :user_id], unique: true
    end
  end
end
