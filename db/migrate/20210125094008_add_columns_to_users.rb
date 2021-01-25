class AddColumnsToUsers < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :username, :string, null: false
    add_column :users, :user_security_question_id, :integer, null: false
    add_column :users, :security_question_answer, :string, null: false
    add_index :users, :username, unique: true
  end
  
  def down
    remove_column :users, :username, :string
    remove_column :users, :user_security_question_id, :integer
    remove_column :users, :security_question_answer, :string
  end
end
