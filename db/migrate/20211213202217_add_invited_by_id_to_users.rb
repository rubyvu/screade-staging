class AddInvitedByIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :invited_by_user_id, :bigint
  end
end
