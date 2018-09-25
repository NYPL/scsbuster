require 'rails_helper'

describe "SCSBuster transfer barcode errors" do
  describe "When on the Transfer Barcode & Update Metadata page" do
  
    before(:each) do
      skip_authentication_to(transfer_metadata_path)
      cut_off_sqs!
    end

    describe "Given a correct bnumber and an invalid barcode is entered" do 
      describe "non-numerical barcodes" do
        
        before(:each) do
          @this_error_barcode = 'x' * 14
          @this_error_bnumber = "b11556466x"
        end
        
        it "should fail non-numerical barcode with error msg" do
          aggregate_failures "check-num" do
            find(:xpath, "//input[@id='barcode']").set("#{@this_error_barcode}")
            find(:xpath, "//input[@id='bib_record_number']").set("#{@this_error_bnumber}")
            click_submit_value("submit")
            within('#flash_error') do
              expect((find(:xpath, "//div[@id='flash_error']/p").text).downcase).to include("must be 14 numerical digits in length")
            end
          end
        end
      end

      describe  "too long barcodes" do

        before(:each) do
          @this_error_barcode = '1' * 15
          @this_error_bnumber = "b11556466x"
        end

        it "should fail too-long barcode with error msg" do
          aggregate_failures "check-long" do
            find(:xpath, "//input[@id='barcode']").set("#{@this_error_barcode}")
            find(:xpath, "//input[@id='bib_record_number']").set("#{@this_error_bnumber}")
            click_submit_value("submit")
            within('#flash_error') do
              expect((find(:xpath, "//div[@id='flash_error']/p").text).downcase).to include("must be 14 numerical digits in length")
            end
          end
        end
      end

      describe  "short barcodes" do

        before(:each) do
          @this_error_barcode = '1' * 13
          @this_error_bnumber = "b11556466x"
        end

        it "should fail short barcode with error msg" do
          aggregate_failures "check-short" do
            find(:xpath, "//input[@id='barcode']").set("#{@this_error_barcode}")
            find(:xpath, "//input[@id='bib_record_number']").set("#{@this_error_bnumber}")
            click_submit_value("submit")
            within('#flash_error') do
              expect((find(:xpath, "//div[@id='flash_error']/p").text).downcase).to include("must be 14 numerical digits in length")
            end
          end
        end
      end

      describe  "empty barcodes" do

        before(:each) do
          @this_error_barcode = ''
          @this_error_bnumber = "b11556466x"
        end

        it "should fail empty barcode with error msg" do
          aggregate_failures "check-short" do
            find(:xpath, "//input[@id='barcode']").set("#{@this_error_barcode}")
            find(:xpath, "//input[@id='bib_record_number']").set("#{@this_error_bnumber}")
            click_submit_value("submit")
            within('#flash_error') do
              expect((find(:xpath, "//div[@id='flash_error']/p").text).downcase).to include("must be 14 numerical digits in length")
            end
          end
        end
      end
    end
  end
end
