class ChangeDefaultStatusForStreamsToInProgress < ActiveRecord::Migration[6.1]
  def self.up
    change_column_default :streams, :status, 'in-progress'
  end
  
  def self.down
    change_column_default :streams, :status, 'pending'
  end
end
