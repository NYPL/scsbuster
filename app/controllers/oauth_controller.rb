require 'oauth2'
require 'securerandom'

class OauthController < ApplicationController
  # OAuth2 authentication process:
  # 1. Construct the authorize URL to ISSO with required parameters, such as,
  # client ID, client secret, redirect URI, state, and scope
  # 2. Redirect the user to the authorize URL for logging in
  # 3. After logged in, redirect the user back to our application.
  # The redirect URL should now come with an authorization code.
  # 4. Get the acceess token with the authorization code by requesting to the access token URL of ISSO.
  # And redirect back to the redirect URI again.
  # 5. Includes the access token we just got in the header for making HTTP requests.
  OAUTH_CLIENT = OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, site: OAUTH_SITE)
  OAUTH_SCOPE  = 'login:staff'

  class << self
    # token is the initalized ACCESS_TOKEN class after successfully called OAUTH_CLIENT.auth_code.get_token
    # in callback method
    attr_accessor :token
  end

  # Redirect the user to NYPL's SSO log in page
  def login
    # If the user hit '/login' to get to the action, do not redirect them back to '/login' again after OAuth
    session[:original_url] = request.path == '/login' ? '/' : request.path

    # Only process OAuth authentication if the access token is not available or the user hit '/login' directly
    if !session[:access_token] || request.path == '/login'
      # Create a random alphanumeric string as the value of state
      # we will put this string in session and use it in callback action to make sure the redirect came from login action
      session[:state] = SecureRandom.alphanumeric(24)

      # Set the authorize URL with required parameters, client ID, client secret, redirect URI, state, and scope
      isso_url = OAUTH_CLIENT.auth_code.authorize_url(:redirect_uri => OAUTH_CALLBACK_URL) + '&state=' + session[:state] + '&scope=' + OAUTH_SCOPE

      # Redirect to the authorize URL
      redirect_to isso_url
    end
  end

  # After back from NYPL's SSO log in page, use the authentication code to get access token
  # It then assigns the received initialized ACCESS_TOKEN to the class variable :token
  def callback
    # Only try to get access token if we have proper parameters,
    # state has to be the same value as we got from login action, and we must have code
    if params[:state] != session[:state] || !params[:code]
      redirect_to '/'
    else
      # Catch the error and proceed to redirenct to '/' if we fail to get the access token
      begin
        # Get the access token and initialize it with ACCESS_TOKEN class
        self.class.token = OAUTH_CLIENT.auth_code.get_token(params[:code], :redirect_uri => OAUTH_CALLBACK_URL)

        session[:access_token] = self.class.token.token
        session[:refresh_token] = self.class.token.refresh_token

        # Now we can put "Authorization: bearer #{session[:access_token]}" in the header when making an HTTP request
        # Or, we can use self.class.token.get self.class.token.post to make requests

        # TODO: we need an authorization to check if the user is on the white list of the scsbuster
        redirect_to session[:original_url]
      rescue
        puts 'Failed to get access token.'
        redirect_to '/'
      end
    end
  end

  # Refresh the access token once it is expired. It then reassign the new initialized ACCESS_TOKEN
  # to the class variable :token
  def refresh_access_token
    self.class.token = self.class.token.refresh!

    session[:access_token] = self.class.token.token
    session[:refresh_token] = self.class.token.refresh_token
  end
end
