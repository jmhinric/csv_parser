# == Schema Information
#
# Table name: cell_ranges
#
#  id               :uuid             not null, primary key
#  type             :string
#  begin_value      :string
#  end_value        :string
#  worksheet_index  :integer
#  data_transfer_id :uuid
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class DestinationCellRange < CellRange
  private

  def cell_col_name
    :destination_col
  end

  def cell_row_name
    :destination_row
  end

  def cell_worksheet_index_name
    :destination_worksheet_index
  end
end
