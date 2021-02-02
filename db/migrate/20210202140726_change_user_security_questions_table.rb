class ChangeUserSecurityQuestionsTable < ActiveRecord::Migration[6.1]
  def up
    # Clear exists question
    UserSecurityQuestion.destroy_all
    
    add_column :user_security_questions, :question_identifier, :string, null: false
    add_index :user_security_questions, :question_identifier, unique: true
    remove_index :user_security_questions, :title
  end
  
  def down
    remove_column :user_security_questions, :question_identifier, :string, null: false
    add_index :user_security_questions, :title, unique: true
  end
end
