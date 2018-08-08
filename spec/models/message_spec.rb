require 'rails_helper'

describe Message do
  #Validations
  it "should validate that barcodes are invalid if they don't fit the format" do
    barcodes_not_array        = Message.new(barcodes: "Garmonbozia")
    barcodes_not_right_length = Message.new(barcodes: ['123', '456', 789])
    
    expect(barcodes_not_array.valid?).to eq(false)
    expect(barcodes_not_right_length.valid?).to eq(false)
  end
  
  it "should validate that barcodes are present" do
    barcodes_missing            = Message.new
    expect(barcodes_missing.valid?).to  eq(false)
  end
  
  #Methods
  it "should return an array of all valid or invalid barcodes when asked" do
    mixed_barcodes        = Message.new(barcodes: ['12345678901234',1,2])
    all_bad_barcodes      = Message.new(barcodes: ['123', '456', 789])
    no_barcodes           = Message.new
    all_good_barcodes     = Message.new(barcodes: [12345678901234, 22345678901235, 32345678901236])
    expect(mixed_barcodes.invalid_barcodes).to eq(['1','2'])
    expect(mixed_barcodes.valid_barcodes).to eq(['12345678901234'])
    expect(all_bad_barcodes.valid_barcodes).to eq([])
    expect(all_bad_barcodes.invalid_barcodes).to eq(['123', '456', '789'])
    expect(all_good_barcodes.valid_barcodes).to eq(['12345678901234', '22345678901235', '32345678901236'])
    expect(all_good_barcodes.invalid_barcodes).to eq([])
    expect(no_barcodes.valid_barcodes).to eq([])
    expect(no_barcodes.invalid_barcodes).to eq([])
  end
  
end