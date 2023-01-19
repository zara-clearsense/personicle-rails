source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
# Use postgres as the database for Active Record
gem 'pg'
gem 'dalli'
gem 'memcachier'
gem 'devise'
gem 'omniauth-oktaoauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'
gem 'activerecord-session_store'
gem 'figaro'
gem "chartkick"
gem "groupdate"
gem 'react-rails'
gem 'jquery-turbolinks'
gem 'will_paginate', '~> 3.3'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'ajax-datatables-rails'
gem 'jquery-datatables'
gem 'rails-i18n', '~> 6.0.0' # For 6.0.0 or higher # GEOCODER #I18n
gem 'geoip'
gem 'geocoder'


# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
gem 'capistrano', '~> 3.4'
gem 'capistrano-rbenv', '~> 2.2'
gem 'capistrano-passenger', '~> 0.2.1'
gem 'capistrano-rails', '~> 1.6', '>= 1.6.2'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
gem 'rest-client'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'
gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  gem "sqlite3", "~> 1.4"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'jquery-rails'
gem 'font-awesome-rails'

group :production do
  gem 'rails_12factor'
end

gem "noticed", "~> 1.5"

gem "sidekiq-scheduler", "~> 4.0"
