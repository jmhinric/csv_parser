require 'rails_helper'

RSpec.describe CellRange, type: :model do
  describe 'validations' do
    context 'single data transfer' do
      let(:range) { create(:single_origin_cell_range, begin_value: 'A5') }

      it 'allows valid begin value and empty end value' do
        expect(range).to be_valid
      end

      it 'validates begin value' do
        range.begin_value = 'a'
        expect(range).not_to be_valid
        expect(range.errors.messages[:begin_value]).to be
      end
    end

    context 'range data transfer' do
      let!(:transfer) { create(:range_data_transfer, origin_cell_range: range) }
      let(:range) { build(:range_origin_cell_range, begin_value: 'A5', end_value: 'A6') }

      it 'allows valid begin value and end values' do
        expect(range).to be_valid
      end

      it 'does not allow invalid begin value' do
        range.begin_value = 'a'
        expect(range).not_to be_valid
        expect(range.errors.messages[:begin_value]).to be

        range.begin_value = nil
        expect(range).not_to be_valid
      end

      it 'does not allow invalid end value' do
        range.end_value = 'a'
        expect(range).not_to be_valid
        expect(range.errors.messages[:end_value]).to be

        range.end_value = nil
        expect(range).not_to be_valid
      end

      describe '#is_a_row_or_column' do
        let(:range) { build(:range_origin_cell_range, begin_value: 'A5', end_value: 'A6') }
        it 'allows columns' do
          expect(range).to be_valid
        end

        it 'allows rows' do
          range.end_value = 'B5'
          expect(range).to be_valid
        end

        it 'fails if not a row or column' do
          range.end_value = 'Z30'
          expect(range).not_to be_valid
        end
      end
    end
  end

  describe '#length' do
    it 'returns nil if no begin value or end value' do
      expect(described_class.new.length).to be_nil
    end

    it 'returns 1 if no end value' do
      expect(described_class.new(begin_value: 'A1').length).to be_nil
    end

    it 'returns 1 if no begin value' do
      expect(described_class.new(end_value: 'A5').length).to be_nil
    end

    it 'returns the length of a column' do
      expect(described_class.new(begin_value: 'A1', end_value: 'A6').length).to eq(6)
    end

    it 'returns the length of a row' do
      expect(described_class.new(begin_value: 'A1', end_value: 'D1').length).to eq(4)
    end
  end
end
