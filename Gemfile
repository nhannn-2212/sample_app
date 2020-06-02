source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.7.1"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "~> 6.0.3", ">= 6.0.3.1"
# Use sqlite3 as the database for Active Record
gem "mysql2"
# Use Puma as the app server
gem "puma", "~> 4.1"
# Use SCSS for stylesheets
gem "bootstrap-sass", "~>3.3.6"
gem "sass-rails", ">= 6"
# Jquery
gem "jquery-rails"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 4.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"
# Use Active Model has_secure_password
gem "bcrypt", "~> 3.1.7"
# gem config
gem "config"
# Use Active Storage variant
# create sample data
gem "faker", "1.7.3"
# Use paginate + bootstrap
gem "bootstrap-will_paginate", "1.0.0"
gem "will_paginate"
# Image processing
gem "image_processing", "1.9.3"
gem "mini_magick", "4.9.5"
# Store image
gem "active_storage_validations", "0.8.2"
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false
# check valid file
gem "file_validators", "~> 2.0", ">= 2.0.2"
# i18n
gem "i18n-js"
gem "rails-i18n"

group :development, :test do
  # Call "byebug" to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages
  # or by calling "console" anywhere in the code.
  gem "listen", "~> 3.2"
  gem "web-console", ">= 3.3.0"
  # Spring speeds up development by
  # keeping your application running in the background
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  # rubocop
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
