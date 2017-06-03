require 'rails_helper'

RSpec.describe CellRange, type: :model do
  describe 'validations' do
    let(:valid_cell_values) { %w(A5 A54 a5 a54 aA5 aA54) }
    let(:invalid_cell_values) { %w(A AA 5 55 54Ab 55Ab45 A5b Ab54ab A5/ a5? .A5) }

    # TODO: Refactor to eliminate redundancy- move to cell_validator_spec
    context 'single data transfer' do
      context 'begin values' do
        it 'allows valid values' do
          valid_cell_values.each do |cell_value|
            expect(build(:single_origin_cell_range, begin_value: cell_value)).to be_valid
            expect(build(:single_destination_cell_range, begin_value: cell_value)).to be_valid
          end
        end

        it 'does not allow invalid values' do
          invalid_cell_values.each do |cell_value|
            expect(build(:single_origin_cell_range, begin_value: cell_value)).not_to be_valid
            expect(build(:single_destination_cell_range, begin_value: cell_value)).not_to be_valid
          end
        end
      end

      context 'end values' do
        it 'allows valid and invalid values' do
          (valid_cell_values + invalid_cell_values).each do |cell_value|
            expect(build(:single_origin_cell_range, end_value: cell_value)).to be_valid
            expect(build(:single_destination_cell_range, end_value: cell_value)).to be_valid
          end
        end
      end
    end

    context 'range data transfer' do
      context 'begin values' do
        it 'allows valid values' do
          valid_cell_values.each do |cell_value|
            expect(build(:range_origin_cell_range, begin_value: cell_value)).to be_valid
            expect(build(:range_destination_cell_range, begin_value: cell_value)).to be_valid
          end
        end

        it 'does not allow invalid values' do
          invalid_cell_values.each do |cell_value|
            expect(build(:range_origin_cell_range, begin_value: cell_value)).not_to be_valid
            expect(build(:range_destination_cell_range, begin_value: cell_value)).not_to be_valid
          end
        end
      end

      context 'end values' do
        it 'allows valid values' do
          valid_cell_values.each do |cell_value|
            expect(build(:range_origin_cell_range, end_value: cell_value)).to be_valid
            expect(build(:range_destination_cell_range, end_value: cell_value)).to be_valid
          end
        end

        it 'does not allow invalid values' do
          invalid_cell_values.each do |cell_value|
            expect(build(:range_origin_cell_range, end_value: cell_value)).not_to be_valid
            expect(build(:range_destination_cell_range, end_value: cell_value)).not_to be_valid
          end
        end
      end
    end
  end
end
