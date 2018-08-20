require 'aws-sdk-sqs'
class SqsClient
  def initialize
    if Rails.env.development?
      Rails.logger.info('Rails ENV is development. Creating client using KEY/SECRET')
      @sqs = Aws::SQS::Client.new(
        region: 'us-east-1',
        access_key_id: AWS_KEY_ID,
        secret_access_key: AWS_SECRET
      )
    else
      Rails.logger.info("Rails ENV is not development. Creating client using ROLE")
      Rails.logger.info("Client credentials at #{AWS_CONTAINER_CREDENTIALS_RELATIVE_URI}")
      @sqs = Aws::SQS::Client.new(region: 'us-east-1')
    end

  end

  def send_message(entries)
    resp = @sqs.send_message_batch({
      queue_url: ENV['SQS_QUEUE_URL'],
      entries: entries,
    })
    resp
  end
end
