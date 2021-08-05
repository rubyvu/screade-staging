class CreateJoinTableStreamTopic < ActiveRecord::Migration[6.1]
  def change
    create_join_table :streams, :topics do |t|
      t.index [:stream_id, :topic_id], unique: true
    end
  end
end
