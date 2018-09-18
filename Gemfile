source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'faraday'
gem 'coffee-rails', '~> 4.2'
gem 'aws-sdk-sqs', '~> 1.3'
gem 'aws-sdk-s3', '~> 1'
gem 'jwt'
gem 'nypl_log_formatter'

# Used in asset pipeline for styling
gem 'design-toolkit', :git => 'https://github.com/NYPL/design-toolkit.git'
gem 'bootsnap', '>= 1.1.0', require: false
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby
gem 'oauth2'

group :development, :test do
  gem 'pry-remote'
  gem 'rubycop'
  gem 'rspec'
  gem 'rspec-rails', '~> 3.7'
  gem 'rails-controller-testing'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'simplecov'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
