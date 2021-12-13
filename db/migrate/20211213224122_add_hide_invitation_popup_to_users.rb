class AddHideInvitationPopupToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :hide_invitation_popup, :boolean, default: false
  end
end
