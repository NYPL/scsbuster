class Item
  extend ActiveModel::Naming

  def initialize
  end
  
  def update_metadata
    require 'aws-sdk-sqs'
    s3 = Aws::S3::Client.new(
      access_key_id: AWS_KEY_ID,
      secret_access_key: AWS_SECRET
    )
    
    sqs = Aws::SQS::Client.new(region: 'us-east-1')
    queue_url = 'https://sqs.us-east-1.amazonaws.com/224280085904/rem-rarities-and-b-sides-temp'
    
    
    resp = sqs.send_message_batch({
      queue_url: queue_url,
      entries: [
        {
          id: '1',
          message_body: 'Crazy'
        },
        {
          id: '2',
          message_body: 'There She Goes Again'
        }, 
        {
          id: '3',
          message_body: 'Burning Down'
        }
      ],
    })
    require 'pry' ; binding.pry;
    
  end
  
  def refile
  end
  
  def transfer_to(bib_id)
  end
end