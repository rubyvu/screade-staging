# Create NewsCategories in DB
NewsCategory::DEFAULT_CATEGORIES.each do |category_title|
  NewsCategory.create_or_find_by(title: category_title)
end

secret_questions = [
  'Test question 1?',
  'Test question 2?',
  'Test question 3?',
  'Test question 4?',
  'Test question 5?'
]
secret_questions.each do |question|
  UserSecurityQuestion.create_or_find_by(title: question)
end
