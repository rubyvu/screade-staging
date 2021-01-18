source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.1.1'

# Use PostgreSQL as the database for Active Record
gem 'pg', '1.2.3'

# Use Puma as the app server
gem 'puma', '5.1.1'

# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
gem 'bootstrap', '~> 4.5.3'

# HTML template engine
gem 'slim-rails'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.2.1'

# Brings Rails named routes to javascript
gem 'js-routes'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.10.1'

# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.16'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# ENV variables
gem 'figaro'

# JSON
gem 'active_model_serializers'

# Web Authentication
gem 'devise'

# Job queue
gem 'que'

# Image processor for uploaded images with ActiveStorage
gem 'mini_magick'
gem 'image_processing'

# Pagination for ActiveRecord
gem 'kaminari'

# Authorization of Models and Parameters
gem 'pundit'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  
  # Tests
  gem 'rspec-rails'
  
  # Fixtures replacement
  gem 'factory_bot_rails'
  
  # Fake data generator for FactoryBot
  gem 'faker'

end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  
  # Mailer
  gem 'letter_opener'
end

group :test do
  # RSpec single line tests
  gem 'shoulda-matchers'
  
  # Template matcher
  gem 'rails-controller-testing'
end
