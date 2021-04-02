class CreateUserTopicSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :user_topic_subscriptions do |t|
      t.integer :user_id, null: false
      t.integer :source_id, null: false
      t.string :source_type, null: false
      t.timestamps
      t.index [:user_id, :source_id, :source_type], unique: true, name: 'index_user_topic_subscriptions_on_user_and_source'
    end
  end
end
