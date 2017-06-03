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

class DataTransfer < ApplicationRecord
  belongs_to :origin_file
  has_one :origin_cell_range, class_name: 'OriginCellRange', validate: true, foreign_key: 'data_transfer_id'
  has_one :destination_cell_range, class_name: 'DestinationCellRange', validate: true, foreign_key: 'data_transfer_id'

  def cells
    origin_cells.map.with_index do |origin_cell, index|
      OpenStruct.new(origin_cell.merge(destination_cells[index]))
    end
  end

  def origin_cells
    origin_cell_range.cells
  end

  def destination_cells
    destination_cell_range.cells
  end
end
