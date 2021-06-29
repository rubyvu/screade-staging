class ChangeIsApprovedForTopics < ActiveRecord::Migration[6.1]
  def up
    change_column :topics, :is_approved, :boolean, default: true
  end
  
  def dowm
    change_column :topics, :is_approved, :boolean, default: false
  end
end
