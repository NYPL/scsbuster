require 'rails_helper'

describe 'SCSBuster Refile query' do
  describe 'When on the Refile page' do
    describe 'Given a valid date range that returns over 50 results' do
      it 'should see some refile error results displayed' do
        aggregate_failures 'check-good-date' do
          stub_refile_error_search_with(page: 1)
          skip_authentication_to(refile_path)

          @this_display_count = find(:xpath, "//p[@class='display-result-text']").text
          @current_month = Time.now.strftime('%m')
          @start_month = @current_month.to_i - 1
          expect(find(:xpath, "//p[@class='display-result-text']").text.downcase).to include('displaying 1-25 of ')

          @current_display_count = find(:xpath, "//p[@class='display-result-text']").text

          @display_count = @this_display_count.downcase.gsub(/displaying 1-25 of (\d+) errors from .*\z/, '\1').to_i
          @display_last_page = (@display_count / 25) + 1
          expect(@display_count.to_i).to be > 50
        end
      end

      it 'should only see a next-link box on first page' do
        aggregate_failures 'check-next-link' do
          stub_refile_error_search_with(page: 1)
          skip_authentication_to(refile_path)

          @next_link_count = all(:xpath, "//nav[@class='nypl-results-pagination']/a[@class='next-link pointer']").size
          expect(@next_link_count).to eq(1)

          @prev_link_count = all(:xpath, "//nav[@class='nypl-results-pagination']/a[@class='previous-link pointer']").size
          expect(@prev_link_count).to eq(0)
        end
      end

      it 'should see previous-link and next-link boxes on second page' do
        aggregate_failures 'check-other-links' do
          stub_refile_error_search_with(page: 2)
          skip_authentication_to(refile_path(page: 2))

          @next_link_count = all(:xpath, "//nav[@class='nypl-results-pagination']/a[@class='next-link pointer']").size
          expect(@next_link_count).to eq(1)

          @prev_link_count = all(:xpath, "//nav[@class='nypl-results-pagination']/a[@class='previous-link pointer']").size
          expect(@prev_link_count).to eq(1)
        end
      end

      describe 'When on the last page' do
        before(:each) do
          stub_refile_error_search_with(page: 4, total: 100)
          skip_authentication_to(refile_path(page: 4))
        end

        it 'should only see a previous-link box' do
          aggregate_failures 'check-last-links' do
            @next_link_count = all(:xpath, "//nav[@class='nypl-results-pagination']/a[@class='next-link pointer']").size
            expect(@next_link_count).to eq(0)

            @prev_link_count = all(:xpath, "//nav[@class='nypl-results-pagination']/a[@class='previous-link pointer']").size
            expect(@prev_link_count).to eq(1)

            # last page should be the same as reported by results-total and page n of n display
            expect(last_page?).to be true
          end
        end

        it 'and clicking previous-link box should go to previous page' do
          find(:xpath, "//nav[@class='nypl-results-pagination']/a[@class='previous-link pointer']").click

          # look for correct next and previous links
          @next_link_count = all(:xpath, "//nav[@class='nypl-results-pagination']/a[@class='next-link pointer']").size
          expect(@next_link_count).to eq(1)

          @prev_link_count = all(:xpath, "//nav[@class='nypl-results-pagination']/a[@class='previous-link pointer']").size
          expect(@prev_link_count).to eq(1)

          this_page_display = find(:xpath, "//nav[@class='nypl-results-pagination']/span[@class='page-count']").text.downcase
          @get_current_page = this_page_display.gsub(/page (\d+) of (\d+)/, '\1')
          @get_last_page = this_page_display.gsub(/page (\d+) of (\d+)/, '\2')

          expect(@get_current_page.to_i).to eq((@get_last_page.to_i - 1))
        end
      end
    end
  end
end
