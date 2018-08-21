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

  class << self
    # token is the initalized ACCESS_TOKEN class after successfully called OAUTH_CLIENT.auth_code.get_token
    # in callback method
    attr_accessor :token
  end

  # Redirect the user to NYPL's SSO log in page
  def authenticate
    # If the user hit '/authenticate' to get to the action, do not redirect them back to '/authenticate' again after OAuth
    session[:original_url] = request.path == authenticate_path ? root_path : request.path
    # Only process OAuth authentication if the access token is not available or the user hit '/authenticate' directly
    if !session[:access_token] || request.path == authenticate_path
      # Create a random alphanumeric string as the value of state
      # we will put this string in session and use it in callback action to make sure the redirect came from authenticate action
      session[:state] = SecureRandom.alphanumeric(24)

      # Set the authorize URL with required parameters, client ID, client secret, redirect URI, state, and scope
      isso_url = OAUTH_CLIENT.auth_code.authorize_url(:redirect_uri => ENV['OAUTH_CALLBACK_URL']) + '&state=' + session[:state] + '&scope=' + OAUTH_SCOPE

      # Redirect to the authorize URL
      redirect_to isso_url
    # If access token exists, check to see whether or not it is expired
    elsif session[:access_token_expires_at] && session[:access_token_expires_at] <= Time.now.to_i
      # Refresh access token if it is expired
      self.refresh_access_token(session[:original_url])
    end
  end

  # After back from NYPL's SSO log in page, use the authentication code to get access token
  # It then assigns the received initialized ACCESS_TOKEN to the class variable :token
  def callback
    # Only try to get access token if we have proper parameters,
    # state has to be the same value as we got from authenticate action, and we must have code
    if params[:state] != session[:state] || !params[:code]
      redirect_to root_path
    else
      # Catch the error and proceed to redirenct to '/' if we fail to get the access token
      begin
        # Get the access token and initialize it with ACCESS_TOKEN class
        self.class.token = OAUTH_CLIENT.auth_code.get_token(params[:code], :redirect_uri => ENV['OAUTH_CALLBACK_URL'])

        session.delete(:access_token)
        session.delete(:refresh_token)
        session.delete(:access_token_expires_at)

        session[:access_token] = self.class.token.token
        session[:refresh_token] = self.class.token.refresh_token
        session[:access_token_expires_at] = self.class.token.expires_at

        # Now we can put "Authorization: bearer #{session[:access_token]}" in the header when making an HTTP request
        # Or, we can use self.class.token.get self.class.token.post to make requests

        # TODO: we need an authorization to check if the user is on the white list of the scsbuster
        redirect_to session[:original_url]
      rescue
        Rails.logger.debug('Failed to get access token.')
        redirect_to root_path
      end
    end
  end

  def log_out(previous_url = root_path)
    session.delete(:access_token)
    session.delete(:refresh_token)
    session.delete(:access_token_expires_at)

    redirect_to 'https://isso.nypl.org/auth/logout'
  end

  protected

  # Refresh the access token once it is expired. It then reassign the new initialized ACCESS_TOKEN
  # to the class variable :token
  #
  # @param [String] previous_url the previous URL that we need to redirect back after getting the new access token
  def refresh_access_token(previous_url = root_path)
    Rails.logger.debug('Going to refresh access token.')

    begin
      self.class.token = self.class.token.refresh!

      session[:access_token] = self.class.token.token
      session[:refresh_token] = self.class.token.refresh_token
      session[:access_token_expires_at] = self.class.token.expires_at

      redirect_to previous_url
    rescue
      Rails.logger.debug('Falied to refresh access token.')
      redirect_to authenticate_path
    end
  end
end
