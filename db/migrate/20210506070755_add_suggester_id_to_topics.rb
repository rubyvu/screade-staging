class AddSuggesterIdToTopics < ActiveRecord::Migration[6.1]
  def up
    add_column :topics, :suggester_id, :integer
  end
  
  def down
    remove_column :topics, :suggester_id
  end
end
