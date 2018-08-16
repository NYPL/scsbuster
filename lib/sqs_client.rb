require 'aws-sdk-sqs'
class SqsClient
  def initialize
    if Rails.env.development?
      @sqs = Aws::SQS::Client.new(
        region: 'us-east-1',
        access_key_id: AWS_KEY_ID,
        secret_access_key: AWS_SECRET
      )
    else
      @sqs = Aws::SQS::Client.new(region: 'us-east-1')
    end

  end

  def send_message(entries)
    resp = @sqs.send_message_batch({
      queue_url: SQS_QUEUE_URL,
      entries: entries,
    })
    resp
  end
end
