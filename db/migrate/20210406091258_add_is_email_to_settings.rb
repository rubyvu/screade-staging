class AddIsEmailToSettings < ActiveRecord::Migration[6.1]
  def up
    add_column :settings, :is_email, :boolean, dafault: true
  end
  
  def down
    remove_column :settings, :is_email
  end
end
