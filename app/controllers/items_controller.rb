class ItemsController < OauthController
  before_action :login

  def refile
    @refile_request = RefileRequest.new
    # TODO: Finish this in subsequent branch.
    if params[:page] && params[:per_page]
      @offset = ( params[:page].to_i - 1 ) * params[:per_page].to_i
    else
      @offset = 0
    end

    date_start = params[:date_start].present? ? params[:date_start] : nil
    date_end = params[:date_end].present? ? params[:date_end] : nil
    @refiles = get_refiles(date_start,date_end,params[:page],params[:per_page])
  end
  
  def update_metadata
    @barcodes = params[:notice].present? && params[:notice]["barcodes"].present? ? params[:notice]["barcodes"] : []
    @protect_cgd = params[:notice].present? && params[:notice]["protect_cgd"].present? ? params[:notice]["protect_cgd"] : false
  end

  def send_metadata
    # don't let it fool you. params[:barcodes] is text.
    barcodes = params[:barcodes].strip.split(/[\W\s]+/)
    message = Message.new(barcodes: barcodes, protect_cgd: params[:protect_cgd], action: 'update')
    if message.valid?
      message.send_update_message_to_sqs
      invalid_barcodes = []
    elsif message.valid_barcodes.present? 
      invalid_barcodes = message.invalid_barcodes
      message.barcodes = message.valid_barcodes
      message.send_update_message_to_sqs
    else
      invalid_barcodes = barcodes
    end
    
    protect_cgd = message.errors.present? ? params[:protect_cgd] : false
    
    if barcodes.blank?
      flash[:error] = "Please enter one or more barcodes."
    elsif invalid_barcodes.present? && message.valid_barcodes.blank?
      flash[:error] = "The barcode(s) remaining are invalid; each barcode must be 14 numerical digits in length. Separate barcodes using commas or returns (new lines)."
    elsif invalid_barcodes.present? && message.valid_barcodes.present?
      flash[:notice] = "Some barcodes were submitted."
      flash[:error] = "The barcode(s) remaining are invalid; each barcode must be 14 numerical digits in length. Separate barcodes using commas or returns (new lines)."
    end
    if message.valid_barcodes.present? && invalid_barcodes.blank?
      flash[:success] = "The barcode(s) have been submitted for processing."
    end
    redirect_to action: 'update_metadata', notice: { barcodes: invalid_barcodes, protect_cgd: protect_cgd}
  end
  
  def transfer_metadata
    @barcode = params[:notice].present? && params[:notice]["barcode"].present? ? params[:notice]["barcode"] : []
    @bib_record_number = params[:notice].present? && params[:notice]["bib_record_number"].present? ? params[:notice]["bib_record_number"] : []
    @protect_cgd = params[:notice].present? && params[:notice]["protect_cgd"].present? ? params[:notice]["protect_cgd"] : []
  end
  
  def send_transfer_metadata
    barcode = params[:barcode].strip
    message = Message.new(barcodes: [barcode], protect_cgd: params[:protect_cgd], action: 'transfer', bib_record_number: params[:bib_record_number])
    invalid_barcode, invalid_bib_record_number = [nil, nil]
    if message.valid?
      message.send_transfer_message_to_sqs
      flash[:success] = "The Transfer & Update request has been submitted."
    elsif !message.valid? && message.errors.present?
      invalid_barcode = barcode
      invalid_bib_record_number = params[:bib_record_number]
      protect_cgd = params[:protect_cgd]
      flash[:errors] = message.errors
    else
      flash[:errors] = "The system encountered an issue. Please retry your submission. If the problem persists, please contact the Digital team at scctech@nypl.org."
    end
    redirect_to action: 'transfer_metadata', notice: { barcode: invalid_barcode, bib_record_number: invalid_bib_record_number, protect_cgd: protect_cgd}
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
