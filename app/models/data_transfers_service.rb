class DataTransfersService
  attr_reader :origin_file, :origin_file_upload, :result_file

  def initialize(origin_file:, origin_file_upload:, result_file:)
    @origin_file = origin_file
    @origin_file_upload = origin_file_upload
    @result_file = result_file
  end

  def self.execute(*args)
    new(*args).execute
  end

  def execute
    origin_file.transfers_by_destination_worksheet.each do |dest_ws_index, dest_transfers|
      dest_ws = result_file[dest_ws_index]

      dest_transfers.group_by(&:origin_worksheet_index).each do |origin_ws_index, transfers|
        origin_ws = origin_file_upload[origin_ws_index]

        transfers.each do |data_transfer|
          dest_cell = cell(data_transfer.destination_row, data_transfer.destination_col, dest_ws)
          origin_cell = cell(data_transfer.origin_row, data_transfer.origin_col, origin_ws)

          dest_cell.raw_value = origin_cell.value
        end
      end
    end

    result_file
  end

  private

  def cell(row, column, worksheet)
    ws_row = worksheet[row]
    cell = ws_row[column] if ws_row

    return cell if ws_row && cell

    worksheet.add_cell(row, column)
  end
end
