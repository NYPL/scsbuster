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

  def stub_refile_error_search_with(options)
    default_options = { page: 1, total: 500, per_page: 25 }
    options = default_options.merge(options)

    results = []
    options[:per_page].times do
      results << { 'id' => rand(1000), 'itemBarcode' => rand(1000), 'createdDate' => random_date, 'updatedDate' => random_date, 'afMessage' => '[A message here]' }
    end

    allow_any_instance_of(RefileErrorSearch).to receive(:get_refiles) { { 'page' => options[:page], 'count' => 25, 'totalCount' => options[:total], 'data' => results } }
  end

  def last_page?
    this_page_display = find(:xpath, "//nav[@class='nypl-results-pagination']/span[@class='page-count']").text.downcase
    get_current_page = this_page_display.gsub(/page (\d+) of (\d+)/, '\1')
    get_last_page = this_page_display.gsub(/page (\d+) of (\d+)/, '\2')
    (get_current_page == get_last_page)
  end

  private

  def random_date(options = { from: 2.years.ago, to: Time.now })
    Time.at(options[:from] + rand * (options[:to].to_f - options[:from].to_f)).to_s
  end
end
