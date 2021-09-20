class RemoveInProgressStartedAtFromStreams < ActiveRecord::Migration[6.1]
  def change
    remove_column :streams, :in_progress_started_at
  end
end
