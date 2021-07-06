# Load files from ./seeds
Dir[ "#{Rails.root}/db/seeds/*.rb" ].map{ |f| load f }

# TODO: Delete after first deploy
# Delete last notifications
Notification.where(source_type: "BreakingNews").destroy_all
# Create admin User
User.create(username: 'admin.screade', email: 'admin@screade.com', password: Random.hex(8), country: Country.find_by(code: 'US'), user_security_question: UserSecurityQuestion.first, security_question_answer: Random.hex(8))
# Delete BreakingNews
BreakingNews.destroy_all

# Set default BreakingNews
BreakingNews.get_breaking_news
