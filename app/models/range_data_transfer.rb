# == Schema Information
#
# Table name: data_transfers
#
#  id             :uuid             not null, primary key
#  origin_file_id :uuid
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  type           :string
#

class RangeDataTransfer < DataTransfer
  validate :range_lengths_equal, if: -> { origin_cell_range && destination_cell_range }

  def transfer_type
    'range'
  end

  private

  def range_lengths_equal
    unequal = origin_cell_range.length != destination_cell_range.length
    errors.add(:destination_cell_range, 'length is unequal to origin_cell_range') if unequal
  end
end
