class ItemsController < OauthController
  before_action :login

  def refile
  end
  
  def update_metadata
    # TODO: if the response is the access token expired, redirect the user to /refresh_access_token
  end

  def send_metadata
    barcodes = params[:barcodes]
    puts barcodes
    flash[:notice] = "Metadata updated for #{barcodes}"
    redirect_to request.referrer
  end
  
  def transfer_metadata
  end
end
