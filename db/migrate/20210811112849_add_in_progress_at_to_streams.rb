class AddInProgressAtToStreams < ActiveRecord::Migration[6.1]
  def up
    add_column :streams, :in_progress_at, :datetime
  end
  
  def down
    remove_column :streams, :in_progress_at
  end
end
