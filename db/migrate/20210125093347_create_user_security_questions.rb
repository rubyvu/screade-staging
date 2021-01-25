class CreateUserSecurityQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :user_security_questions do |t|
      t.string :title, null: false
      t.index :title, unique: true
    end
  end
end
