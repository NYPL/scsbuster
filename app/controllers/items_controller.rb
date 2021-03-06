class ItemsController < OauthController
  before_action :authenticate

  def refile
    @barcode = params[:barcode]
    if params[:page] && params[:per_page]
      @offset = ( params[:page].to_i - 1 ) * params[:per_page].to_i
    else
      @offset = 0
    end
    
    @this_start_date = params[:date_start].present? ? Date.parse(params[:date_start]) : Date.today - 1
    @this_end_date = params[:date_end].present? ? Date.parse(params[:date_end]) : Date.today

    @refile_error_search = RefileErrorSearch.new(
      date_start: @this_start_date,
      date_end: @this_end_date,
      page: params[:page],
      per_page: params[:per_page]
    )

    @refiles = @refile_error_search.get_refiles
  end

  def update_metadata
    @barcodes = params[:barcodes] ||= []
    @protect_cgd = params[:protect_cgd]
  end

  def send_metadata
    # don't let it fool you. params[:barcodes] is text.
    user = User.new(access_token: session[:access_token])
    user_email = user.get_email_address
    barcodes = params[:barcodes].strip.split(/[\W\s]+/)
    message = Message.new(barcodes: barcodes, protect_cgd: params[:protect_cgd], action: 'update', user_email: user_email)
    if message.valid?
      message.send_update_message_to_sqs
    elsif message.valid_barcodes.present?
      valid_barcodes_message = Message.new(barcodes: message.valid_barcodes, protect_cgd: params[:protect_cgd], action: 'update', user_email: user_email)
      valid_barcodes_message.send_update_message_to_sqs
    end

    message.protect_cgd = nil if message.errors.blank?

    if barcodes.blank?
      flash[:error] = "Please enter one or more barcodes."
    elsif message.invalid_barcodes.present? && message.valid_barcodes.blank?
      flash[:error] = "The barcode(s) remaining are invalid; each barcode must be 14 numerical digits in length. Separate barcodes using commas or returns (new lines)."
    elsif message.invalid_barcodes.present? && message.valid_barcodes.present?
      flash[:notice] = "Some barcodes were submitted."
      flash[:error] = "The barcode(s) remaining are invalid; each barcode must be 14 numerical digits in length. Separate barcodes using commas or returns (new lines)."
    end
    if message.valid_barcodes.present? && message.invalid_barcodes.blank?
      flash[:success] = "The barcode(s) have been submitted for processing."
    end
    redirect_to action: 'update_metadata', barcodes: message.invalid_barcodes, protect_cgd: message.protect_cgd
  end

  def transfer_metadata
    @barcode = params[:barcode] ||= []
    @bib_record_number = params[:bib_record_number] ||= []
    @protect_cgd = params[:protect_cgd]
  end

  def send_transfer_metadata
    barcode = params[:barcode].strip
    user = User.new(access_token: session[:access_token])
    user_email = user.get_email_address
    message = Message.new(barcodes: [barcode], protect_cgd: params[:protect_cgd], action: 'transfer', bib_record_number: params[:bib_record_number], user_email: user_email)
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
    redirect_to action: 'transfer_metadata', barcode: invalid_barcode, bib_record_number: invalid_bib_record_number, protect_cgd: protect_cgd
  end
  
  def search_refile_errors
    refile_error_search = params['refile_error_search']
    begin
      date_start = Date.new(refile_error_search["date_start(1i)"].to_i, refile_error_search["date_start(2i)"].to_i, refile_error_search["date_start(3i)"].to_i)
      date_end = Date.new(refile_error_search["date_end(1i)"].to_i, refile_error_search["date_end(2i)"].to_i, refile_error_search["date_end(3i)"].to_i)
    rescue Exception => e
      flash[:date_error] = 'Please enter a valid date range.'
    end
    redirect_to action: 'refile', date_start: date_start, date_end: date_end
  end 
  
  def send_refile_request
    barcode = params[:barcode].strip
    refile_message = RefileRequest.new(barcode: barcode)
    if refile_message.valid?
      refile_message.post_refile
      flash[:success] = "The barcode has been submitted for processing."
    else
      flash[:error] = refile_message.errors
    end
    redirect_to action: 'refile', barcode: refile_message.valid? ? nil : refile_message.barcode
  end
end
