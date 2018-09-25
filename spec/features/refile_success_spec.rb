require 'rails_helper'

describe 'SCSBuster Refile success' do
  describe 'When on the Refile page' do
    describe 'When a correct barcode number is entered' do
      before(:each) do
        allow_any_instance_of(RefileErrorSearch).to receive(:get_refiles) { {} }
        # Don't actually hit the refile request endpoint
        allow_any_instance_of(RefileRequest).to receive(:post_refile) { {} }
        skip_authentication_to(refile_path) { nil }
        @good_barcode = 'b11556466x'
      end

      it ' - normal 20-digit barcode should display success message' do
        aggregate_failures 'check-success' do
          find(:xpath, "//input[@id='barcode']").set(@good_barcode)
          find(:xpath, "//form[@action='/send_refile_request']/div/div[@class='nypl-submit-button-wrapper']/input[@type='submit']").click

          within('.nypl-form-success') do
            expect(find(:xpath, "//div[@class='nypl-form-success']/h2").text.downcase).to include('success')
            expect(find(:xpath, "//div[@class='nypl-form-success']/p").text.downcase).to include('the barcode has been submitted for processing')
          end
        end
      end

      it ' - non-numeric barcode b12345x should display success message' do
        aggregate_failures 'check-nonnum' do
          fill_in('barcode', with: 'b12345x')
          find(:xpath, "//form[@action='/send_refile_request']/div/div[@class='nypl-submit-button-wrapper']/input[@type='submit']").click

          within('.nypl-form-success') do
            expect(find(:xpath, "//div[@class='nypl-form-success']/h2").text.downcase).to include('success')
            expect(find(:xpath, "//div[@class='nypl-form-success']/p").text.downcase).to include('the barcode has been submitted for processing')
          end
        end
      end
    end
  end
end
