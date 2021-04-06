class RenameContactToContactUsRequest < ActiveRecord::Migration[6.1]
  def up
    rename_table :contacts, :contact_us_requests
  end

  def down
    rename_table :contact_us_requests, :contacts
  end
end
