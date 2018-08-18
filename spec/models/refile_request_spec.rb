require 'rails_helper'

describe RefileRequest do
  #Validations
  it "should validate that barcodes are invalid if they don't fit the format" do
    barcodes_not_right_length   = RefileRequest.new(barcode: '123456789012345678901')
    expect(barcodes_not_right_length.valid?).to   eq(false)
  end
  
  #Methods
  it "should return invalid barcodes" do 
    invalid_barcode_request           = RefileRequest.new(barcode: "GarmonboziaGarmonboziaGarmonbozia")
    expect(invalid_barcode_request.invalid_barcode).to eq("GarmonboziaGarmonboziaGarmonbozia")
  end
  
  it "should return nil if barcode is valid and it is asked for invalid barcodes" do
    valid_barcode_request             = RefileRequest.new(barcode: '1234567890abcdefghij')
    expect(valid_barcode_request.invalid_barcode).to  eq(nil)
  end
end