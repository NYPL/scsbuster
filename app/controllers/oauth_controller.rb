class OauthController < ApplicationController
  def login
    require 'oauth2'
    
    client = OAuth2::Client.new('client_id', 'client_secret', :site => 'https://isso.nypl.org')
    client.auth_code.authorize_url(:redirect_uri => 'http://localhost:3000/oauth2/callback')
    # => "https://example.org/oauth/authorization?response_type=code&client_id=client_id&redirect_uri=http://localhost:8080/oauth2/callback"

    token = client.auth_code.get_token('authorization_code_value', :redirect_uri => 'http://localhost:3000/oauth2/callback', :headers => {'Authorization' => 'Basic some_password'})
    response = token.get('/api/resource', :params => { 'query_foo' => 'bar' })
    response.class.name
    # => OAuth2::Response
  end
end
