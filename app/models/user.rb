class User
  include ActiveModel::Model
  attr_accessor :access_token

  # Get the authorized user list from S3
  def self.get_authorized_list
    authorized_list = nil
    begin
      # Construct the S3 client instance in different ways based on different environments
      if Rails.env.development?
        s3 = Aws::S3::Client.new({
          access_key_id: ENV['AWS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET'],
          region: ENV['SQS_REGION']
        })
      else
        s3 = Aws::S3::Client.new({
          region: ENV['SQS_REGION']
        })
      end

      # response.body returns a StringIO instance
      response = s3.get_object({ bucket: 'nypl-platform-admin', key: 'authorization.json' })
      authorized_list = response.body.read
    rescue Aws::S3::Errors::ServiceError
      Rails.logger.debug('Failed to get the authorized user list from AWS S3.')
    end
    authorized_list
  end

  # Get the logged in user's email from the access token. The access token is encoded as a JWT
  def get_email_address
    if access_token
      decoded_token_array = JWT.decode access_token, nil, false
      # First item of the array is the payload of the JWT encoded token. "sub" is the key of email value
      email_address = decoded_token_array.first.fetch('sub')
    else
      email_address = nil
    end

    email_address
  end
  
  def is_authorized?
    authorized_list = User.get_authorized_list

    # See if the logged in user listed in the authorized user list
    user_authorized = authorized_list ? authorized_list.include?(self.get_email_address) : false
    user_authorized
  end
end
