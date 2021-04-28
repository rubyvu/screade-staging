class AddResolvedColumnsToContactUsRequests < ActiveRecord::Migration[6.1]
  def up
    add_column :contact_us_requests, :resolved_at, :datetime
    add_column :contact_us_requests, :resolved_by, :string
  end
  
  def down
    remove_column :contact_us_requests, :resolved_at
    remove_column :contact_us_requests, :resolved_by
  end
end
