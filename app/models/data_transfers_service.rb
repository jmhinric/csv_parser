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
          dest_cell(data_transfer, dest_ws).raw_value = origin_cell(data_transfer, origin_ws).value
        end
      end
    end

    result_file
  end

  private

  def dest_cell(data_transfer, worksheet)
    row = data_transfer.destination_row
    col = data_transfer.destination_col

    ws_row = worksheet[row]
    cell = ws_row[col] if ws_row

    return cell if ws_row && cell

    worksheet.add_cell(row, col)
  end

  def origin_cell(data_transfer, worksheet)
    row = data_transfer.origin_row
    col = data_transfer.origin_col

    ws_row = worksheet[row]
    cell = ws_row[col] if ws_row

    return cell if ws_row && cell

    worksheet.add_cell(row, col)
  end
end
