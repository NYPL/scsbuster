class Message
  extend ActiveModel::Naming
  include ActiveModel::Validations
  attr_accessor :barcodes, :user_email, :protect_cgd, :action, :bib_record_number
  
  validate :barcode_format
  
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
    require 'aws-sdk-sqs'
    s3 = Aws::S3::Client.new(
      access_key_id: AWS_KEY_ID,
      secret_access_key: AWS_SECRET
    )
    
    sqs = Aws::SQS::Client.new(region: 'us-east-1')
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
    s3 = Aws::S3::Client.new(
      access_key_id: AWS_KEY_ID,
      secret_access_key: AWS_SECRET
    )
    
    sqs = Aws::SQS::Client.new(region: 'us-east-1')
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
  
  def barcode_format
    if barcodes.blank? 
      errors.add(:barcodes, "No barcodes present.")
    end
    if !barcodes.is_a?(Array)
      errors.add(:barcodes, "Barcodes not an array.")
    end
    if invalid_barcodes.count > 0
      errors.add(:barcodes, "Invalid barcodes present.")
    end
  end
end