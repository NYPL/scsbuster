require File.join(Rails.root, 'lib', 'sqs_client')

module Helpers
  def skip_authentication_to(path)
    allow_any_instance_of(OauthController).to receive(:authenticate) { true }
    visit path
  end

  def click_submit_value(action)
    find(:xpath, "//input[@type='submit' and translate(@value,'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')='#{action}']").click
  end

  def cut_off_sqs!
    allow_any_instance_of(SqsClient).to receive(:send_message) { true }
  end
end
