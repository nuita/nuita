source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.2'

gem "devise", ">= 4.7.1"
gem 'carrierwave'
gem "mini_magick", ">= 4.9.4"
gem 'fog-aws'

gem 'serviceworker-rails'

gem 'omniauth', '~>1.9'
gem 'omniauth-twitter'
gem 'omniauth-rails_csrf_protection', '~> 0.1'
gem 'twitter'

gem 'faker'

gem "nokogiri", ">= 1.10.4"
gem 'valid_url'
gem 'fastimage'
gem 'camo'

gem 'mysql2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use Puma as the app server
gem 'puma', '~> 3.12'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

gem 'ed25519'
gem 'bcrypt_pbkdf'

gem 'slim-rails'
gem 'html2slim'

gem 'bootstrap', '>= 4.3.1'
gem 'jquery-rails'
gem 'font-awesome-sass', '~> 5.9.0'

gem 'will_paginate'
gem 'will_paginate-bootstrap4'

# Use CoffeeScript for .coffee assets and views
#gem 'coffee-rails', '~> 4.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'webpacker', git: 'https://github.com/rails/webpacker.git'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-rake'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

group :production, :staging do
  gem 'unicorn'
  gem 'google-analytics-rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
