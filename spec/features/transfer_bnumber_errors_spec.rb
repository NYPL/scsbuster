require 'rails_helper'

describe 'SCSBuster transfer barcode with bnumber errors' do
  describe "When on the Transfer Barcode & Update Metadata page" do

    before(:each) do
      skip_authentication_to(transfer_metadata_path)
      cut_off_sqs!
    end

    describe 'Given an invalid bnumber and a correct barcode is entered' do 
      describe 'too long bnumbers' do

        before(:each) do
          @this_error_barcode = '1' * 14
          @this_error_bnumber = 'b' + ('1' * 9) + 'x'
        end

        it 'should fail too-long bnumber with error msg' do
          aggregate_failures 'check-long' do
            find(:xpath, "//input[@id='barcode']").set("#{@this_error_barcode}")
            find(:xpath, "//input[@id='bib_record_number']").set("#{@this_error_bnumber}")
            click_submit_value('submit')
            within('#flash_error') do
              expect((find(:xpath, "//div[@id='flash_error']/p").text).downcase).to include('the bib record number must be 10 characters long and start with "b"')
            end
          end
        end
      end

      describe 'too short bnumbers' do

        before(:each) do
          @this_error_barcode = '1' * 14
          @this_error_bnumber = 'b' + ('1' * 7) + 'x'
        end

        it 'should fail too-short bnumber with error msg' do
          aggregate_failures 'check-short' do
            find(:xpath, "//input[@id='barcode']").set("#{@this_error_barcode}")
            find(:xpath, "//input[@id='bib_record_number']").set("#{@this_error_bnumber}")
            click_submit_value('submit')
            within('#flash_error') do
              expect((find(:xpath, "//div[@id='flash_error']/p").text).downcase).to include('the bib record number must be 10 characters long and start with "b"')
            end
          end
        end
      end

      describe 'empty bnumbers' do

        before(:each) do
          @this_error_barcode = '1' * 14
          @this_error_bnumber = ''
        end

        it 'should fail empty bnumber with error msg: bib record number is blank' do
          aggregate_failures 'check-empty' do
            find(:xpath, "//input[@id='barcode']").set("#{@this_error_barcode}")
            find(:xpath, "//input[@id='bib_record_number']").set("#{@this_error_bnumber}")
            click_submit_value('submit')
            within('#flash_error') do
              expect((find(:xpath, "//div[@id='flash_error']/p").text).downcase).to include('bib record number is blank')
            end
          end
        end
      end

      describe 'When a malformed bnumber is entered' do

        describe "starting with a wrong letter" do
          before(:each) do
            @this_error_barcode = '1' * 14
            @this_error_bnumber = 'a' + ('1' * 8)
          end

          it 'should fail bnumber a11111111 with error msg' do
            aggregate_failures 'check-start-with-a' do
              find(:xpath, "//input[@id='barcode']").set("#{@this_error_barcode}")
              find(:xpath, "//input[@id='bib_record_number']").set("#{@this_error_bnumber}")
              click_submit_value('submit')
              within('#flash_error') do
                expect((find(:xpath, "//div[@id='flash_error']/p").text).downcase).to include('the bib record number must be 10 characters long and start with "b"')
              end
            end
          end
        end

        describe "containing all numbers" do
          before(:each) do
            @this_error_barcode = '1' * 14
            @this_error_bnumber = '1' * 10
          end

          it 'should fail bnumber 1111111111 with error msg' do
            aggregate_failures 'check-all-numbers' do
              find(:xpath, "//input[@id='barcode']").set("#{@this_error_barcode}")
              find(:xpath, "//input[@id='bib_record_number']").set("#{@this_error_bnumber}")
              click_submit_value('submit')
              within('#flash_error') do
                expect((find(:xpath, "//div[@id='flash_error']/p").text).downcase).to include('the bib record number must be 10 characters long and start with "b"')
              end
            end
          end
        end

        describe "containing an extra letter" do
          before(:each) do
            @this_error_barcode = '1' * 14
            @this_error_bnumber = 'bb' + ('1' * 8) 
          end

          it "should fail bnumber #{@this_error_bnumber} - bb11111111 with error msg" do
            aggregate_failures 'check-extra-b' do
              find(:xpath, "//input[@id='barcode']").set("#{@this_error_barcode}")
              find(:xpath, "//input[@id='bib_record_number']").set("#{@this_error_bnumber}")
              click_submit_value('submit')
              within('#flash_error') do
                expect((find(:xpath, "//div[@id='flash_error']/p").text).downcase).to include('the bib record number must be 10 characters long and start with "b"')
              end
            end
          end
        end
      end
    end
  end
end
