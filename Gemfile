source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Errors and performance monitoring
gem 'airbrake'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'

# Use PostgreSQL as the database for Active Record
gem 'pg', '1.2.3'

# Use Puma as the app server
gem 'puma'

# Redis for ActionCable
gem 'redis'

# Admin panel
gem 'activeadmin'

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
gem 'que', '~> 1.0.0.beta4'
gem 'que-web'
gem 'que-scheduler'

# AWS S3 adapter for Carrierwave
gem 'fog-aws'
gem 'aws-sdk-s3'
gem 'aws-sdk-mediapackage'
gem 'aws-sdk-medialive'

# File uploading
gem 'carrierwave'
gem 'carrierwave_direct'
gem 'carrierwave-video-thumbnailer'
gem 'mimemagic', '0.3.7'

# Image processor for uploaded images with Carrierwave
gem 'mini_magick'

# Pagination for ActiveRecord
gem 'kaminari'

# Authorization of Models and Parameters
gem 'pundit'

# All countries
gem 'city-state'

# News API
gem 'news-api'

# Geocoder
gem 'geocoder'

# Detect language for NewsArticle
gem 'cld'

# Global Search
gem 'searchkick'
gem 'faraday_middleware-aws-sigv4'

# Firebase Cloud Messaging
gem 'fcm'

# Twilio audio/video call
gem 'twilio-ruby'
# Wrap link
gem 'rails_autolink'

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
  
  # Generate PDF schema of the database
  gem 'rails-erd'
end

group :test do
  # RSpec single line tests
  gem 'shoulda-matchers'
  
  # Template matcher
  gem 'rails-controller-testing'
end
