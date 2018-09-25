require 'rails_helper'

describe "SCSBuster transfer barcode errors" do

	describe "When on the Transfer Barcode & Update Metadata page" do
	
		before(:each) do
      skip_authentication_to(transfer_metadata_path)
		end

		describe "Given an incorrect barcode is entered" do 
		
			#describe "It should fail for these conditions:" do
			
				# 				before(:all) do
				# 
				# 					if (defined?(ENV['ERROR_BARCODE']) && ENV['ERROR_BARCODE'] != nil) then
				# 						@this_error_barcode = ENV['ERROR_BARCODE']
				# 					else
				# 						#insert "good" slug here.
				# 						@this_error_barcode = "33433047299254"
				# 					end
				# 
				# 					if (defined?(ENV['ERROR_BNUMBER']) && ENV['ERROR_BNUMBER'] != nil) then
				# 						@this_error_bnumber = ENV['ERROR_BNUMBER']
				# 					else
				# 						#insert "good" slug here.
				# 						@this_error_bnumber = "b11556466x"
				# 					end
				# 
				# 				
				# 				end

				# this first block is for inline-testing of barcode errors, normally will be commented out

				# 				if (defined?(ENV['ERROR_BARCODE']) && ENV['ERROR_BARCODE'] != nil) 
				# 
				# 					it " - generic error for #{ENV['ERROR_BARCODE']} displays:  (WIP)" do
				# 
				# 						aggregate_failures "check-generic" do
				# 
				# 							#puts "this_error_barcode: #{@this_error_barcode}/#{ENV['ERROR_BARCODE']}"
				# 							#puts "this_error_bnumber: #{@this_error_bnumber}/#{ENV['ERROR_BNUMBER']}"
				# 	
				# 							save_snap("pre_generic","png")
				# 							#save_snap("pre_generic","html")
				# 				
				# 							find(:xpath, "//input[@id='barcode']").set("#{@this_error_barcode}")
				# 
				# 							find(:xpath, "//input[@id='bib_record_number']").set("#{@this_error_bnumber}")
				# 
				# 							click_submit_value("submit")
				# 
				# 							sleep 2
				# 							save_snap("post_generic","png")
				# 							#save_snap("post_generic","html")
				# 
				# 							within('#flash_error') do
				# 					
				# 								expect((find(:xpath, "//div[@id='flash_error']/p").text).downcase).to include("must be 14 numerical digits in length")
				# 
				# 				
				# 								#expect(fail-message).to eq("fail-message")
				# 					
				# 							end
				# 					
				# 						end
				# 				
				# 					end
				# 					
				# 				#/if-filter
				# 				end

				describe "When a non-numerical barcode is entered" do
					
					before(:each) do
						@this_error_barcode = 'x' * 14
						@this_error_bnumber = "b11556466x"
					end
					
					it "it should fail with error msg: must be 14 numerical digits in length" do

						aggregate_failures "check-num" do

							find(:xpath, "//input[@id='barcode']").set("#{@this_error_barcode}")

							find(:xpath, "//input[@id='bib_record_number']").set("#{@this_error_bnumber}")

							click_submit_value("submit")

							within('#flash_error') do
								expect((find(:xpath, "//div[@id='flash_error']/p").text).downcase).to include("must be 14 numerical digits in length")
							end
						
						#/aggregate_failures
						end
					
					#/it-block
					end
				
				end

				describe	"When a too long barcode is entered" do

					before(:each) do
						@this_error_barcode = '1' * 15
						@this_error_bnumber = "b11556466x"
					end

					it "it should fail with error msg: must be 14 numerical digits in length" do

						aggregate_failures "check-long" do

							find(:xpath, "//input[@id='barcode']").set("#{@this_error_barcode}")

							find(:xpath, "//input[@id='bib_record_number']").set("#{@this_error_bnumber}")

							click_submit_value("submit")

							within('#flash_error') do
								expect((find(:xpath, "//div[@id='flash_error']/p").text).downcase).to include("must be 14 numerical digits in length")
							end
					
						#/aggregate_failures
						end
				
					#/it-block
					end
				
				end

				describe	"When a too short barcode is entered" do

					before(:each) do
						@this_error_barcode = '1' * 13
						@this_error_bnumber = "b11556466x"
					end

					it "it should fail with error msg: must be 14 numerical digits in length" do

						aggregate_failures "check-short" do

							find(:xpath, "//input[@id='barcode']").set("#{@this_error_barcode}")

							find(:xpath, "//input[@id='bib_record_number']").set("#{@this_error_bnumber}")

							click_submit_value("submit")

							within('#flash_error') do
								expect((find(:xpath, "//div[@id='flash_error']/p").text).downcase).to include("must be 14 numerical digits in length")
							end
					
						#/aggregate_failures
						end
				
					#/it-block
					end
				
				end



# temp block
# 				it " - too long barcode 12345678123456781234567 (error msg: must be 14 numerical digits in length)" do
# 
# 
# 					aggregate_failures "check-long" do
# 
# 						save_snap("pre_long","png")
# 						#save_snap("pre_long","html")
# 				
# 						find(:xpath, "//input[@id='barcode']").set("123456781234567812345678")
# 						find(:xpath, "//input[@id='bib_record_number']").set("b11556466x")
# 
# 						click_submit_value("submit")
# 
# 						sleep 2
# 						save_snap("post_long","png")
# 						#save_snap("post_long","html")
# 
# 						within('#flash_error') do
# 					
# 							expect((find(:xpath, "//div[@id='flash_error']/p").text).downcase).to include("must be 14 numerical digits in length")
# 
# 				
# 							#expect(fail-message).to eq("fail-message")
# 					
# 						end
# 					
# 					end
# 				
# 				#/it-block
# 				end
# 
# 				it " - empty barcode (error msg: must be 14 numerical digits in length)" do
# 
# 					aggregate_failures "check-empty" do
# 
# 						save_snap("pre_empty","png")
# 						#save_snap("pre_empty","html")
# 				
# 						find(:xpath, "//input[@id='barcode']").set("")
# 						find(:xpath, "//input[@id='bib_record_number']").set("b11556466x")
# 
# 						click_submit_value("submit")
# 
# 						sleep 2
# 						save_snap("post_empty","png")
# 						#save_snap("post_empty","html")
# 
# 						within('#flash_error') do
# 					
# 							expect((find(:xpath, "//div[@id='flash_error']/p").text).downcase).to include("must be 14 numerical digits in length")
# 
# 				
# 							#expect(fail-message).to eq("fail-message")
# 					
# 						end
# 					
# 					end
				

				# 			<div class="nypl-text-field-with-label">
				#         <label class="required">Barcode</label><span class="nypl-required-field"> Required</span>
				#         <input type="text" name="barcode" id="barcode" value="" class="required">
				#         <span class="nypl-field-status" id="barcodes-status" aria-live="assertive" aria-atomic="true">Enter a single barcode.</span>
				#       </div>
			
				#       				#expect(fail-message).to eq("fail-message")
				
			
			#/inner-inner-inner-describe-it-should-fail-for-these-conditions
			#end
		
		#/inner-inner-describe-
		end

	end
	
end
