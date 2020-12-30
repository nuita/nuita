source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'devise', '>= 4.7.1'
gem 'carrierwave'
gem 'mini_magick', '>= 4.9.4'
gem 'fog-aws'

gem 'serviceworker-rails'

gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-rails_csrf_protection'
gem 'twitter'

gem 'faker'

gem 'nokogiri', '>= 1.10.4'
gem 'valid_url'
gem 'fastimage'
gem 'panchira'

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

gem 'sprockets', '3.7.2' # 4への移行作業するよりwebpack使うべき……？

gem 'ed25519'
gem 'bcrypt_pbkdf'

gem 'slim-rails'
gem 'html2slim'

gem 'bootstrap', '>= 4.3.1'
gem 'jquery-rails'
gem 'toastr-rails'

gem 'will_paginate'
gem 'will_paginate-bootstrap4'

# Use CoffeeScript for .coffee assets and views
#gem 'coffee-rails', '~> 4.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

gem 'webpacker'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'capistrano', '3.14.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-rake'
  gem 'bullet'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'simplecov', require: false
  gem 'codecov', require: false
end

group :production, :staging do
  gem 'unicorn'
  gem 'google-analytics-rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
