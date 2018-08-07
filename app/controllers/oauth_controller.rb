class OauthController < ApplicationController
    def initialize
        require 'oauth2'
        require 'securerandom'

        # OAuth2 authentication process:
        # 1. Construct the authorize URL to ISSO with required parameters, such as,
        # client ID, client secret, redirect URI, state, and scope
        # 2. Redirect the user to the authorize URL for logging in
        # 3. After logged in, redirect the user back to our application.
        # The redirect URL should now come with an authorization code.
        # 4. Get the acceess token with the authorization code by requesting to the access token URL of ISSO.
        # And redirect back to the redirect URI again.
        # 5. Includes the access token we just got in the header for making HTTP requests.

        # Set up the variables for OAuth2 Client instance and ISSO log in URL
        client_id      = CLIENT_ID
        client_secret  = CLIENT_SECRET
        oauth_site     = OAUTH_SITE
        @redirect_uri  = OAUTH_CALLBACK_URL
        @state         = SecureRandom.alphanumeric(24)
        @scope         = 'login:staff'

        # Construct the OAuth2 client instance
        @client = OAuth2::Client.new(
            client_id,
            client_secret,
            site: oauth_site
        )
    end

    def login
        # TODO: Check the URL link pattern to see if it matches the pattern /auth/provider or /callback
        # If no, check the log in status. If not, start OAuth authentication process
        session[:original_url] = request.path

        if !session[:access_token]
             # Set the authorize URL with required parameters, client ID, client secret, redirect URI, state, and scope
            isso_url = @client.auth_code.authorize_url(:redirect_uri => @redirect_uri) + '&state=' + @state + '&scope=' + @scope

            # Redirect to the authorize URL
            redirect_to isso_url
        end
    end

    def callback
        # Get the access token and other params with the authorization code, params[:code]
        token = @client.auth_code.get_token(params[:code], :redirect_uri => @redirect_uri)
        session[:access_token] = token.token
        session[:refresh_token] = token.refresh_token

        # Now we can put "Authorization: bearer token.token" in the header when making an HTTP request
        # TODO: we need an authorization to check if the user is on the white list of the scsbuster

        redirect_to session[:original_url]
    end

    def refresh_oauth_token
        #TODO: Request to refresh the token
    end
end
