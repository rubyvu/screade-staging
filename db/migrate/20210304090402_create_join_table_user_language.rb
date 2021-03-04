class CreateJoinTableUserLanguage < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :languages do |t|
      t.index [:user_id, :language_id]
    end
  end
end
