# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

CLIENT_ID = ENV['CLIENT_ID']
CLIENT_SECRET = ENV['CLIENT_SECRET']
REFILE_REQUEST_SECRET = ENV['REFILE_REQUEST_SECRET']
OAUTH_CALLBACK_URL = ENV['OAUTH_CALLBACK_URL']
OAUTH_AUTH_URL = ENV['OAUTH_AUTH_URL']
OAUTH_TOKEN_URL = ENV['OAUTH_TOKEN_URL']
DEV_PLATFORM_BASE_URL = ENV['DEV_PLATFORM_BASE_URL']
PLATFORM_BASE_URL = ENV['PLATFORM_BASE_URL']
TOKEN_URL_FOR_NYPL_API_CLIENT = ENV['TOKEN_URL_FOR_NYPL_API_CLIENT']
SQS_REGION = ENV['SQS_REGION']
SQS_API = ENV['SQS_API']
