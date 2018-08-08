class ItemsController < ApplicationController
  def refile
    @refile_request = RefileRequest.new
    if params[:page] && params[:per_page]
      @offset = ( params[:page].to_i - 1 ) * params[:per_page].to_i
    else
      @offset = 0
    end
    
    date_start = params[:date_start].present? ? params[:date_start] : Date.today - 1
    date_end = params[:date_end].present? ? params[:date_end] : Date.today.strftime("%Y-%d-%m")   
    @refiles = get_refiles(date_start,date_end,params[:page],params[:per_page])
  end
  
  def update_metadata
    @barcodes = params[:notice].present? && params[:notice]["barcodes"].present? ? params[:notice]["barcodes"] : []
  end
  
  def send_metadata
    # don't let it fool you. params[:barcodes] is text.
    barcodes = params[:barcodes].strip.split(/[\W\s]+/)
    message = Message.new(barcodes: barcodes, protect_cgd: params[:protect_cgd], action: 'update')
    if message.valid?
      message.send_update_message_to_sqs
      @invalid_barcodes = []
    elsif message.valid_barcodes.present? 
      @invalid_barcodes = message.invalid_barcodes
      message.barcodes = message.valid_barcodes
      message.send_update_message_to_sqs
    else
      @invalid_barcodes = barcodes
    end
    
    if barcodes.blank?
      flash[:error] = "Please enter one or more barcodes."
    elsif @invalid_barcodes.present? && message.valid_barcodes.blank?
      flash[:error] = "The barcode(s) remaining are invalid; each barcode must be 14 numerical digits in length. Separate barcodes using commas or returns (new lines)."
    elsif @invalid_barcodes.present? && message.valid_barcodes.present?
      flash[:notice] = "Some barcodes were submitted."
      flash[:error] = "The barcode(s) remaining are invalid; each barcode must be 14 numerical digits in length. Separate barcodes using commas or returns (new lines)."
    end
    if message.valid_barcodes.present? && @invalid_barcodes.blank?
      flash[:success] = "The barcode(s) have been submitted for processing."
    end
    redirect_to action: 'update_metadata', notice: { barcodes: @invalid_barcodes }
  end
  
  def transfer_metadata
    @barcode = params[:notice].present? && params[:notice]["barcode"].present? ? params[:notice]["barcode"] : []
    @bib_record_number = params[:notice].present? && params[:notice]["bib_record_number"].present? ? params[:notice]["bib_record_number"] : []
  end
  
  def send_transfer_metadata
    # TODO: Add all the validation and error handling.
    # don't let it fool you. params[:barcodes] is text.
    barcode = params[:barcode].strip
    message = Message.new(barcodes: [barcode], protect_cgd: params[:protect_cgd], action: 'transfer', bib_record_number: params[:bib_record_number])
    if barcode && barcode.length != 14
      @invalid_barcode = barcode
      flash[:error] = "Please enter a valid 14-digit barcode."
    else
      message.send_transfer_message_to_sqs
      flash[:success] = "The barcode has been transferred."
    end
    redirect_to action: 'transfer_metadata', notice: { barcode: @invalid_barcode }
  end
  
  private
  
  def get_refiles(date_start, date_end, page, per_page)
    @refile_request.date_start = date_start
    @refile_request.date_end = date_end
    @refile_request.page = page
    @refile_request.per_page = per_page
    @refile_request.get_refiles
  end
end
