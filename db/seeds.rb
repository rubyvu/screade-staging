# Create NewsCategories in DB
NewsCategory::DEFAULT_CATEGORIES.each do |category_title|
  NewsCategory.create_or_find_by(title: category_title)
end

secret_questions = [
  { title: 'Test question 1?', question_identifier: 'q_1' },
  { title: 'Test question 2?', question_identifier: 'q_2' },
  { title: 'Test question 3?', question_identifier: 'q_3' },
  { title: 'Test question 4?', question_identifier: 'q_4' },
  { title: 'Test question 5?', question_identifier: 'q_5' }
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
