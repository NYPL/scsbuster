class OauthController < ApplicationController
  def login
    require 'oauth2'
    require 'securerandom'

    # TODO: Do we have ISSO log in cookies? Should we have one?
    # TODO: Check the URL link pattern to see if it matches the pattern /auth/provider or /callback
    # If no, check the log in status. If not log in

    client_id     = CLIENT_ID
    client_secret = CLIENT_SECRET
    authorize_url = OAUTH_AUTH_URL
    token_url     = OAUTH_TOKEN_URL
    redirect_uri  = 'http://local.nypl.org:3001/callback'
    login_url     = OAUTH_LOGIN_URL

    state = SecureRandom.alphanumeric(24)

    client = OAuth2::Client.new(client_id, client_secret, site: 'https://isso.nypl.org')
    isso_url = client.auth_code.authorize_url(:redirect_uri => redirect_uri) + '&state=' + state + '&scope=login:staff'

    redirect_to isso_url
  end

  def callback
    puts 'callback!!'

    redirect_uri  = 'http://local.nypl.org:3001/callback'
    client_id     = CLIENT_ID
    client_secret = CLIENT_SECRET

    client = OAuth2::Client.new(client_id, client_secret, site: 'https://isso.nypl.org')
    token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)

    puts token.token
    puts token.expires_in
    puts token.refresh_token
    puts token.options
    puts token.params

    # Now we can put "Authorization: bearer token.token" in the header when making an HTTP request
    # TODO: we need an authorization to check if the user is on the white list of the scsbuster
  end

  def refresh_oauth_token
  end
end
