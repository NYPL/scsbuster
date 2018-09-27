require 'rails_helper'

describe 'Update metadata errors' do
  describe 'When on the Update SCSB Metadata page' do

    before(:each) do
      skip_authentication_to(update_metadata_path)
      cut_off_sqs!
    end

    describe 'It should fail for these conditions' do
      it ' - non-numerical barcode (error msg: must be 14 numerical digits in length)' do
        aggregate_failures 'check-num' do
          fill_in('barcodes', with: 'abcdefghijklmn')
          click_submit_value('submit')
          within('#flash_error') do
            expect(find(:xpath, "//div[@id='flash_error']/p").text.downcase).to include('must be 14 numerical digits in length')
          end
        end
      end

      it ' - too long barcode (error msg: must be 14 numerical digits in length)' do
        aggregate_failures 'check-long' do
          fill_in('barcodes', with: '1' * 15)
          click_submit_value('submit')
          within('#flash_error') do
            expect(find(:xpath, "//div[@id='flash_error']/p").text.downcase).to include('must be 14 numerical digits in length')
          end
        end
      end

      it ' - too short barcode (error msg: must be 14 numerical digits in length)' do
        aggregate_failures 'check-short' do
          fill_in('barcodes', with: '1' * 13)
          click_submit_value('submit')
          within('#flash_error') do
            expect(find(:xpath, "//div[@id='flash_error']/p").text.downcase).to include('the barcode(s) remaining are invalid', 'each barcode must be 14 numerical digits in length', 'separate barcodes using commas or returns (new lines)')
          end
        end
      end

      it ' - empty barcode (error msg: please enter one or more barcodes)' do
        aggregate_failures 'check-short' do
          fill_in('barcodes', with: '')
          click_submit_value('submit')
          within('#flash_error') do
            expect(find(:xpath, "//div[@id='flash_error']/p").text.downcase).to include('please enter one or more barcodes')
          end
        end
      end
    end
  end
end
