require 'aws-sdk-sqs'

class Message
  extend ActiveModel::Naming
  include ActiveModel::Validations
  attr_accessor :barcodes, :user_email, :protect_cgd, :action, :bib_record_number
  
  validate :barcode_format, :bib_record_number_format
  
  def initialize params = {}
    params.each { |key, value| send "#{key}=", value }
  end
  
  def valid_barcodes
    if barcodes && barcodes.is_a?(Array)
      barcodes.map!(&:to_s) 
      barcodes.select{ |b| b[/^\d{14}$/] }
    else
      []
    end
  end
  
  def invalid_barcodes
    invalid = []
    if barcodes && barcodes.is_a?(Array)
      invalid = barcodes 
      invalid = invalid - valid_barcodes
    end
    return invalid
  end
  
  def send_update_message_to_sqs
    sqs = Aws::SQS::Client.new(
      region: 'us-east-1',
      access_key_id: AWS_KEY_ID,
      secret_access_key: AWS_SECRET
    )
    queue_url = SQS_QUEUE_URL
    entries = [
        {
          id: self.barcodes.first,
          message_body: "{
            \"barcodes\": #{self.barcodes},
            \"protectCGD\": #{self.protect_cgd},
            \"action\": \"#{self.action}\",
            \"email\": \"kristopherkelly@nypl.org\"
            }"
        }
      ]
    
    resp = sqs.send_message_batch({
      queue_url: queue_url,
      entries: entries,
    })
    resp
  end
  
  def send_transfer_message_to_sqs
    require 'aws-sdk-sqs'
    sqs = Aws::SQS::Client.new(
      region: 'us-east-1',
      access_key_id: AWS_KEY_ID,
      secret_access_key: AWS_SECRET
    )
    queue_url = SQS_QUEUE_URL
    entries = [
        {
          id: self.barcodes.first,
          message_body: "{
            \"barcodes\": #{self.barcodes},
            \"protectCGD\": #{self.protect_cgd},
            \"action\": \"#{self.action}\",
            \"bibRecordNumber\": \"#{self.bib_record_number}\",
            \"email\": \"kristopherkelly@nypl.org\"
            }"
        }
      ]
    
    resp = sqs.send_message_batch({
      queue_url: queue_url,
      entries: entries,
    })
    resp
  end
  
  private
  
  def bib_record_number_format
    return if action != 'transfer'
    errors.add(:bib_record_number, "Bib record number is blank.") if self.bib_record_number.blank? && self.action == 'transfer'
    errors.add(:bib_record_number, "The bib record number must be 10 characters long and start with \"b\". Example: b12345678x.") if self.bib_record_number.present? && self.action == 'transfer' && !self.bib_record_number.match?(/^[b]\d{8}[x|\d]$/)
  end
  
  def barcode_format
    if barcodes.blank? 
      errors.add(:barcodes, "No barcodes present.")
    end
    if !barcodes.is_a?(Array)
      errors.add(:barcodes, "Barcodes not an array.")
    end
    if invalid_barcodes.count > 0
      errors.add(:barcodes, "Barcode(s) must be 14 numerical digits in length.")
    end
  end
end