class AddVersionToContactUsRequests < ActiveRecord::Migration[6.1]
  def up
    add_column :contact_us_requests, :version, :string, default: '0'
  end
  
  def down
    remove_column :contact_us_requests, :version
  end
end
