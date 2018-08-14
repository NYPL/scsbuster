# Model represents NYPL refile api request, both for get and post requests.
class RefileRequest
  require 'json'
  require 'net/http'
  require 'uri'
  
  attr_accessor :bearer, :page, :per_page, :success, :date_start, :date_end
  
  # Authorizes the request. 
  def assign_bearer
    begin
      uri = URI.parse(API_AUTH_URL)
      request = Net::HTTP::Post.new(uri)
      request.basic_auth(API_CLIENT_ID,API_CLIENT_SECRET)
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
  
  def get_refiles
    require 'net/http'
    require 'uri'
    self.bearer     = self.assign_bearer
    date_start      = Date.today - 10000 if date_start.blank?
    date_end        = Date.today if date_end.blank?
    success         = 'false' if success.blank? # I'm not 100% sure this is really necessary. We may always just want it to be false. 
    this_start = date_start.strftime('%Y-%m-%d') + 'T00:00:00-00:00'
    this_end = date_end.strftime('%Y-%m-%d') + 'T23:59:59-00:00'
    page = 1 if page.blank?
    per_page = 25 if per_page.blank?
    offset = (page - 1) * per_page
    request_string = "#{API_BASE_URL}/recap/refile-requests?createdDate=[#{this_start},#{this_end}]&success=#{success}&offset=#{offset}&limit=#{per_page}&includeTotalCount=true"
    puts request_string
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