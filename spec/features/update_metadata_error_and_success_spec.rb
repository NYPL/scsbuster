require 'rails_helper'

describe 'SCSBuster update metadata multi-modal errors' do
  describe 'When on the Update SCSB Metadata page' do
    describe 'When 2 incorrect and 8 valid barcodes are entered' do
      before(:each) do
        cut_off_sqs!
        @valid_barcode = '1' * 14

        skip_authentication_to(update_metadata_path)
        fill_in('barcodes', with: "#{@valid_barcode}\n#{@valid_barcode}\n#{@valid_barcode}\n#{@valid_barcode}\n#{@valid_barcode}\n#{@valid_barcode}\n#{@valid_barcode}\n#{@valid_barcode}\n54321\n123456789012345678901\n")
        click_submit_value('submit')
      end

      it '8 valid barcodes should display a success message' do
        aggregate_failures 'check-newline' do
          within('.nypl-form-success') do
            expect(find(:xpath, "//div[@class='nypl-form-success']/p").text.downcase).to include('some barcodes were submitted')
          end
        end
      end

      it '2 invalid barcodes should display error messages' do
        aggregate_failures 'check-errors' do
          within('#flash_error') do
            expect(find(:xpath, "//div[@id='flash_error']/p").text.downcase).to include('the barcode(s) remaining are invalid', 'each barcode must be 14 numerical digits in length', 'separate barcodes using commas or returns (new lines)')
          end
        end
      end

      it '2 invalid barcodes should remain in barcode field' do
        aggregate_failures 'check-errors' do
          expect(find(:xpath, "//div[@class='nypl-text-area-with-label'][1]/textarea[@name='barcodes']").text.downcase).to include('54321', '123456789012345678901')
        end
      end
    end
  end
end
