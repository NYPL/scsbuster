# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

AWS_KEY_ID=ENV['AWS_KEY_ID']
AWS_SECRET=ENV['AWS_SECRET']
API_AUTH_URL=ENV['API_AUTH_URL']
API_BASE_URL=ENV['API_BASE_URL']
API_CLIENT_ID=ENV['API_CLIENT_ID']
API_CLIENT_SECRET=ENV['API_CLIENT_SECRET']
SQS_QUEUE_URL=ENV['SQS_QUEUE_URL']