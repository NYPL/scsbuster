class ItemsController < OauthController
  before_action :login

  def refile
  end
  
  def update_metadata
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
