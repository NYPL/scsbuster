require 'aws-sdk-sqs'

class Item
  extend ActiveModel::Naming
  include ActiveModel::Model
  attr_accessor :year, :month

  def update_metadata
    s3 = Aws::S3::Client.new(
      access_key_id: AWS_KEY_ID,
      secret_access_key: AWS_SECRET
    )

    sqs = Aws::SQS::Client.new(region: 'us-east-1')
    queue_url = SQS_QUEUE_URL
    some_array_of_entries = [
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
      ]

    resp = sqs.send_message_batch({
      queue_url: queue_url,
      entries: some_array_of_entries,
    })
  end

  def refile
  end

  def transfer_to(bib_id)
  end
end
