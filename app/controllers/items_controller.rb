class ItemsController < OauthController
  before_action :login

  def refile
  end
  
  def update_metadata
  end
  
  def send_metadata
    # TODO: inherite the method to check log in status, if not logged in, redirect to /login,
    # If the response is the access token expired, redirect the user to /refresh_access_token

    barcodes = params[:barcodes]
    puts barcodes
    flash[:notice] = "Metadata updated for #{barcodes}"
    redirect_to request.referrer
  end
  
  def transfer_metadata
  end
end
