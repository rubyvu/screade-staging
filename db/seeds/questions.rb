secret_questions = [
  { title: 'In what county were you born?', question_identifier: 'q_1' },
  { title: 'What is your oldest cousin’s first name?', question_identifier: 'q_2' },
  { title: 'In what city or town did your mother and father meet?', question_identifier: 'q_3' },
  { title: 'What month and day is your anniversary? ', question_identifier: 'q_4' },
  { title: 'What is the middle name of your oldest child?', question_identifier: 'q_5' }
]

secret_questions.each do |question_params|
  next if UserSecurityQuestion.exists?(question_params)
  
  current_question = UserSecurityQuestion.find_by(question_identifier: question_params[:question_identifier])
  if current_question
    current_question.update_columns(title: question_params[:title])
  else
    UserSecurityQuestion.create(question_params)
  end
end
