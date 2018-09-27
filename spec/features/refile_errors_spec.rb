require 'rails_helper'

describe 'SCSBuster Refile errors' do
  describe 'When on the Refile page' do
    before(:each) do
      # So the controller doesn't try to fetch paginated refile errors from LSP
      allow_any_instance_of(RefileErrorSearch).to receive(:get_refiles) { {} }
      skip_authentication_to(refile_path)
    end

    describe 'Given an incorrect barcode is entered' do
      describe 'When barcode is too long' do
        before(:each) do
          @this_error_barcode = '1' * 21
        end

        it ' - 21 character barcode should display error msg: must be up to 20 alphanumeric characters in length' do
          aggregate_failures 'check-num' do
            fill_in('barcode', with: @this_error_barcode)
            click_button('refileRequestSubmitButton')
            within('#flash_error') do
              expect(find(:xpath, "//div[@id='flash_error']/p").text.downcase).to include('the barcode must be up to 20 alphanumeric characters in length')
            end
          end
        end

        it ' - and too long barcode should remain on form' do
          fill_in('barcode', with: @this_error_barcode)
          click_button('refileRequestSubmitButton')
          expect(all(:xpath, "//div[@class='nypl-text-field-with-label']/input[@id='barcode' and @value='#{@this_error_barcode}']").size).to eq(1)
        end
      end

      describe 'When barcode is empty' do
        before(:each) do
          fill_in('barcode', with: '')
          click_button('refileRequestSubmitButton')
        end

        it ' - should display error msg: must be up to 20 alphanumeric characters in length' do
          aggregate_failures 'check-empty' do
            within('#flash_error') do
              expect(find(:xpath, "//div[@id='flash_error']/p").text.downcase).to include('the barcode must be up to 20 alphanumeric characters in length')
            end
          end
        end

        it ' - and should display error msg: please enter a barcode' do
          expect(find(:xpath, "//div[@id='flash_error']/p").text.downcase).to include('please enter a barcode')
        end
      end
    end
  end
end
