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
  OAUTH_CLIENT = OAuth2::Client.new(ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], site: ENV['OAUTH_SITE'])
  OAUTH_SCOPE  = 'login:staff'

  def login
    # If the user hit '/login' to get to the action, do not redirect them back to '/login' again after OAuth
    session[:original_url] = request.path == '/login' ? '/' : request.path

    # Only process OAuth authentication if the access token is not available or the user hit '/login' directly
    if !session[:access_token] || request.path == '/login'
      # Create a random alphanumeric string as the value of state
      # we will put this string in session and use it in callback action to make sure the redirect came from login action
      session[:state] = SecureRandom.alphanumeric(24)

      # Set the authorize URL with required parameters, client ID, client secret, redirect URI, state, and scope
      isso_url = OAUTH_CLIENT.auth_code.authorize_url(:redirect_uri => ENV['OAUTH_CALLBACK_URL']) + '&state=' + session[:state] + '&scope=' + OAUTH_SCOPE

      # Redirect to the authorize URL
      redirect_to isso_url
    end
  end

  def callback
    # Only try to get access token if we have proper parameters,
    # state has to be the same value as we got from login action, and we must have code
    if params[:state] != session[:state] || !params[:code]
      redirect_to '/'
    else
      # Catch the error and proceed to redirenct to '/' if we fail to get the access token
      begin
        # Get the access token and other params with the authorization code, params[:code]
        token = OAUTH_CLIENT.auth_code.get_token(params[:code], :redirect_uri => ENV['OAUTH_CALLBACK_URL'])
        session[:access_token] = token.token
        session[:refresh_token] = token.refresh_token

        # Now we can put "Authorization: bearer #{session[:access_token]}" in the header when making an HTTP request
        # TODO: we need an authorization to check if the user is on the white list of the scsbuster
        redirect_to session[:original_url]
      rescue
        redirect_to '/'
      end
    end
  end

  def refresh_oauth_token
    #TODO: Request to refresh the token
  end
end
