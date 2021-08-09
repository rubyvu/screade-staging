class AddGroupFieldsToStreams < ActiveRecord::Migration[6.1]
  def change
    add_column :streams, :group_id, :integer
    add_column :streams, :group_type, :string
  end
end
