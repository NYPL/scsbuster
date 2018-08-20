require 'json'
require 'net/http'
require 'uri'

# Model represents a search for RefileErrors
class RefileErrorSearch
  include ActiveModel::Model

  attr_writer :page, :per_page, :date_start,:date_end
  attr_accessor :bearer

  # Authorizes the request.
  def assign_bearer
    begin
      uri = URI.parse(OAUTH_TOKEN_URL)
      request = Net::HTTP::Post.new(uri)
      request.basic_auth(CLIENT_ID,CLIENT_SECRET)
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
        # TODO: Log this a-somewhere, plz.
      end
    rescue Exception => e
      # TODO: Log this a-somewhere, plz.
      self.bearer = nil
    end
  end

  def date_start
    @date_start || Date.today - 10000
  end

  def date_end
    @date_end || Date.today
  end

  def page
    @page.present? ? @page.to_i : 1
  end

  def per_page
    @per_page.present? ? @per_page.to_i : 25
  end

  def get_refiles
    self.bearer     = self.assign_bearer
    this_start = date_start.strftime('%Y-%m-%d') + 'T00:00:00-00:00'
    this_end = date_end.strftime('%Y-%m-%d') + 'T23:59:59-00:00'
    offset = (page - 1) * per_page
    request_string = "#{API_BASE_URL}/recap/refile-errors?createdDate=[#{this_start},#{this_end}]&offset=#{offset}&limit=#{per_page}&includeTotalCount=true"
    uri = URI.parse(request_string)
    request = Net::HTTP::Get.new(uri)
    request["Accept"] = "application/json"
    request["Authorization"] = "Bearer #{self.bearer}"

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
