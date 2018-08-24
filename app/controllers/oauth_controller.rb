require 'oauth2'
require 'securerandom'
require 'aws-sdk-s3'

class OauthController < ApplicationController
  # OAuth2 authentication process:
  # 1. Construct the authorize URL to ISSO with required parameters, such as,
  # client ID, client secret, redirect URI, state, and scope.
  # 2. Redirect the user to the authorize URL for logging in
  # 3. After logged in, redirect the user back to our application.
  # The redirect URL should now come with an authorization code.
  # 4. Get the acceess token with the authorization code by requesting to the access token URL of ISSO.
  # And redirect back to the redirect URI again.
  OAUTH_CLIENT = OAuth2::Client.new(ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], site: ENV['OAUTH_SITE'])
  OAUTH_SCOPE  = 'openid login:staff offline_access'

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
        token = OAUTH_CLIENT.auth_code.get_token(params[:code], :redirect_uri => ENV['OAUTH_CALLBACK_URL'])

        # Clear the old session, if we happened to have any
        [:access_token, :refresh_token, :access_token].each { |key| session.delete(key) }

        session[:access_token] = token.token
        session[:refresh_token] = token.refresh_token
        session[:access_token_expires_at] = token.expires_at

        # Check if the user is on the white list of the scsbuster
        if is_user_authorized
          redirect_to session[:original_url]
        else
          Rails.logger.debug('The user is not authorized.')
          redirect_to '/error?message=user_not_authorized'
        end

      rescue
        Rails.logger.debug('Failed to get access token.')
        redirect_to root_path
      end
    end
  end

  # Log out the user by clearing the session
  def log_out
    reset_session
    redirect_to root_path
  end

  protected

  # Refresh the access token once it is expired. It then reassign the new initialized ACCESS_TOKEN
  # to the class variable :token
  #
  # @param [String] previous_url the previous URL that we need to redirect back after getting the new access token
  def refresh_access_token(previous_url = root_path)
    Rails.logger.debug('Going to refresh access token.')

    # Set the parametets to call refresh access token API
    begin
      refresh_params = {
        grant_type: 'refresh_token',
        refresh_token: session[:refresh_token],
        client_id: ENV['CLIENT_ID'],
        client_secret: ENV['CLIENT_SECRET']
      }

      new_token = OAUTH_CLIENT.get_token(refresh_params)
      new_token.refresh_token = session[:refresh_token] unless new_token.refresh_token

      # Clear the old session
      reset_session

      session[:access_token] = new_token.token
      session[:refresh_token] = new_token.refresh_token
      session[:access_token_expires_at] = new_token.expires_at

      redirect_to previous_url
    rescue
      Rails.logger.debug('Falied to refresh access token.')
      redirect_to authenticate_path
    end
  end

  # The method to check if the logged in user on the authorized user list
  # It will request the list from our AWS S3 then compare the email addresses
  def is_user_authorized
    if session[:access_token]
      # Get the logged in user's email from the access token
      decoded_token_array = JWT.decode session[:access_token], nil, false
      # First item of the array is the payload of the JWT encoded token. sub is the key of email value
      user_email = decoded_token_array.first.fetch('sub')
    else
      user_email = nil
    end

    # Get the authorized user list from S3
    begin
      s3 = Aws::S3::Client.new({
        access_key_id: ENV['AWS_KEY_ID'],
        secret_access_key: ENV['AWS_SECRET'],
        region: ENV['SQS_REGION']
      })
      # response.body returns a StringIO instance
      response = s3.get_object({ bucket: 'nypl-platform-admin', key: 'authorization.json' })
      authorized_user_list = response.body.read
    rescue Aws::S3::Errors::ServiceError
      Rails.logger.debug('Failed to get the authorized user list from AWS S3.')
    end

    # See if the logged in user listed in the authorized user list
    user_authorized = authorized_user_list ? authorized_user_list.include?(user_email) : false

    user_authorized
  end
end
