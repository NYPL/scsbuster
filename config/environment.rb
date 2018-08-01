# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

AWS_KEY_ID=ENV['AWS_KEY_ID']
AWS_SECRET=ENV['AWS_SECRET']
SQS_QUEUE_URL=ENV['SQS_QUEUE_URL']