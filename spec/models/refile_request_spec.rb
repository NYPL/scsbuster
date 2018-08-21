require 'rails_helper'

describe RefileRequest do
  describe 'Validations' do

    it 'is invalid without a barcode' do
      refile_request = RefileRequest.new
      expect(refile_request).to_not be_valid
      expect(refile_request.errors.messages[:barcode]).to include('Please enter a barcode.')
    end

    it 'validates that barcodes are 20 characters or fewer' do
      short  = RefileRequest.new(barcode: 'xxx')
      expect(short).to be_valid

      twenty = RefileRequest.new(barcode: ('x1' * 10))
      expect(twenty).to be_valid

      long = RefileRequest.new(barcode: 'x1' * 111)
      expect(long).to_not be_valid

      empty = RefileRequest.new(barcode: '')
      expect(empty).to_not be_valid
    end
  end
end
