class User
  include ActiveModel::Model
  attr_accessor :access_token

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
end
