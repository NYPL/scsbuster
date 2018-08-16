require 'aws-sdk-sqs'
class SqsClient
  def initialize
    @sqs = Aws::SQS::Client.new(
      region: 'us-east-1',
      access_key_id: AWS_KEY_ID,
      secret_access_key: AWS_SECRET
    )
  end

  def send_message(entries)
    resp = @sqs.send_message_batch({
      queue_url: SQS_QUEUE_URL,
      entries: entries,
    })
    resp
  end
end
