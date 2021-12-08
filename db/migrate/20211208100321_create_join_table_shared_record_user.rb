class CreateJoinTableSharedRecordUser < ActiveRecord::Migration[6.1]
  def change
    create_join_table :shared_records, :users do |t|
      # t.index [:shared_record_id, :user_id]
      # t.index [:user_id, :shared_record_id]
    end
  end
end
