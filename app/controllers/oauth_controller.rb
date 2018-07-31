class OauthController < ApplicationController
  def login
    require 'oauth2'

    # TODO: Do we have ISSO log in cookies? Should we have one?

    # TODO: Check the URL link pattern to see if it matches the pattern /auth/provider or /callback

    # If no, check the log in status. If not log in
    # redirect to the linke as below for putting in credientials
    # https://isso.nypl.org/oauth/authorize?response_type=code&redirect_uri=http%3A%2F%2Flocal.nypl.org%3A3001%2Fcallback&scope=openid%20login%3Astaff&state=PBIXrTuYhHP1kwbK39YAgQCE&client_id=platform_admin
    # The user submits the credentials on the ISSO form. ISSO from redirect the user back to the application
    # When back to the application, sending the request to get access token
    # With the access token, go to the first page

    # TODO: we need an authorization to check if the user is on the white list of the scsbuster

    client_id     = CLIENT_ID
    client_secret = CLIENT_SECRET
    authorize_url = OAUTH_AUTH_URL
    token_url     = OAUTH_TOKEN_URL
    redirect_uri  = OAUTH_CALLBACK_URL
    login_url     = OAUTH_LOGIN_URL

    client = OAuth2::Client.new(client_id, client_secret, :authorize_url => authorize_url, :token_url => token_url)
    puts "REDIRECT: " + redirect_uri
    puts "CLIENT_SECRET: " + client_secret
    puts "CLIENT_ID: " + client_id
    puts "AUTHORIZE_URL: " + authorize_url
    puts "TOKEN_URL: " + token_url
    puts "LOGIN URL: " + login_url

    client.auth_code.authorize_url(:redirect_uri => redirect_uri)


    # token = client.auth_code.get_token('authorization_code_value', :redirect_uri => 'http://localhost:3000/oauth2/callback', :headers => {'Authorization' => 'Basic some_password'})
    # response = token.get('/api/resource', :params => { 'query_foo' => 'bar' })
    # response.class.name
    # # => OAuth2::Response
  end

  def callback
    puts 'callback!!'
  end
end
