require 'json'
require 'net/http'
require 'uri'

# Model represents NYPL refile api request, both for get and post requests.
class RefileRequest
  extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Model
  attr_accessor :bearer, :barcode

  validates :barcode, format: { with: /\A\w{1,20}\z/, message: 'The barcode must be up to 20 alphanumeric characters in length.'}
  validates_presence_of :barcode, message: 'Please enter a barcode.'

  # Authorizes the request.
  def assign_bearer
    begin
      uri = URI.parse(ENV['OAUTH_TOKEN_URL'])
      request = Net::HTTP::Post.new(uri)
      request.basic_auth(ENV['CLIENT_ID'],ENV['CLIENT_SECRET'])
      request.set_form_data(
        "grant_type" => "client_credentials"
      )

      req_options = {
        use_ssl: uri.scheme == "https",
        request_timeout: 500
      }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end

      if response.code == '200'
        self.bearer = JSON.parse(response.body)["access_token"]
      else
        self.bearer = nil
        Rails.logger.warn("Bad response getting bearer token, response code is #{response.code}")
      end
    rescue Exception => e
      Rails.logger.error("Error getting bearer #{e.backtrace}")
      self.bearer = nil
    end
  end

  def post_refile
    self.bearer     = self.assign_bearer
    uri = URI.parse("#{ENV['API_BASE_URL']}/recap/refile-requests")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Accept"] = "application/json"
    request["Authorization"] = "Bearer #{self.bearer}"
    request.body = JSON.dump({
      "itemBarcode" => self.barcode
    })

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    if response.code == "200"
      JSON.parse(response.body)
    else
      # TODO: Log this.
      {}
    end
  end

end
