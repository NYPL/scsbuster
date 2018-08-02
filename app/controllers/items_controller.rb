class ItemsController < ApplicationController
  def refile
  end
  
  def update_metadata
  end
  
  def send_metadata
    barcodes = params[:barcodes]
    flash[:errors] = @errors.join('; ')
    flash[:notice] = "Metadata updated for #{barcodes}"
    redirect_to request.referrer 
  end
  
  def transfer_metadata
  end
end
