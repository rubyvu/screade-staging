class AddInProgressStartedAtToStreams < ActiveRecord::Migration[6.1]
  def up
    add_column :streams, :in_progress_started_at, :datetime, default: DateTime.current
  end
  
  def down
    remove_column :streams, :in_progress_started_at
  end
end
