source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'carrierwave'
gem 'devise', '>= 4.7.1'
gem 'fog-aws'
gem 'mini_magick', '>= 4.9.4'

gem 'serviceworker-rails'

gem 'omniauth'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-twitter'
gem 'twitter'

gem 'faker'

gem 'fastimage'
gem 'nokogiri', '>= 1.10.4'
gem 'panchira'
gem 'valid_url'

gem 'mysql2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# bootstrapが動かない問題への一時的な対応策
gem 'bootstrap', '4.6.0'
gem 'jquery-rails'
gem 'sprockets', '3.7.2' 

gem 'webpacker'
gem 'webpacker-pwa'

gem 'bcrypt_pbkdf'
gem 'ed25519'

gem 'html2slim'
gem 'slim-rails'
gem 'will_paginate'
gem 'will_paginate-bootstrap4'

gem 'mimemagic', '~> 0.3.6'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'bullet'
  gem 'capistrano', '3.14.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rake'
  gem 'capistrano-rbenv'
  gem 'rubocop', require: false
  gem 'rubocop-minitest', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'codecov', require: false
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'webdrivers'
end

group :production, :staging do
  gem 'google-analytics-rails'
  gem 'unicorn'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
