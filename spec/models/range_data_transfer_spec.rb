require 'rails_helper'

RSpec.describe RangeDataTransfer, type: :model do
  describe 'range_lengths_equal' do
    let(:origin) { build(:range_origin_cell_range, begin_value: 'A1', end_value: 'A5') }
    let(:destination) { build(:range_destination_cell_range, begin_value: 'B1', end_value: 'B5') }
    let(:transfer) do
      build(:range_data_transfer, origin_cell_range: origin, destination_cell_range: destination)
    end

    it 'is valid with equal cell ranges' do
      expect(transfer).to be_valid
    end

    it 'is invalid with unequal cell ranges' do
      origin.end_value = 'A6'
      expect(transfer).not_to be_valid
    end
  end
end
