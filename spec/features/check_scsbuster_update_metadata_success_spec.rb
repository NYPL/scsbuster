require 'rails_helper'

describe 'update metadata single barcode success' do
  describe 'When on the Update SCSB Metadata page' do

    describe 'When valid barcode number is  entered' do
      before(:each) do
        cut_off_sqs!
        skip_authentication_to(update_metadata_path)
        @good_barcode = '1' * 14
      end

      it 'a single valid barcode should display a success message' do
        aggregate_failures 'check-success' do
          fill_in('barcodes', with: @good_barcode)
          click_submit_value('submit')
          within('.nypl-form-success') do
            expect(find(:xpath, "//div[@class='nypl-form-success']/h2").text.downcase).to include('success')
            expect(find(:xpath, "//div[@class='nypl-form-success']/p").text.downcase).to include('the barcode(s) have been submitted for processing')
          end
        end
      end
    end
  end
end
