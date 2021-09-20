class RemoveInProgressAtFromStreams < ActiveRecord::Migration[6.1]
  def change
    remove_column :streams, :in_progress_at
  end
end
