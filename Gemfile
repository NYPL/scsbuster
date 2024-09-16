source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails'
gem 'sass-rails'
gem 'uglifier'
gem 'faraday'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'aws-sdk-sqs'
gem 'aws-sdk-s3'
gem 'jwt'
gem 'nypl_log_formatter'

# Used in asset pipeline for styling
gem 'design-toolkit', :git => 'https://github.com/NYPL/design-toolkit.git'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'oauth2'

group :development, :test do
  gem 'pry-remote'
  gem 'rubycop'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'capybara'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  gem 'simplecov'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
