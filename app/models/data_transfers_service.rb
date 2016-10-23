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
      dest_worksheet = result_file[dest_ws_index]
      # TODO: Find the worksheet by user-entered worksheet name instead of index
      # dest_worksheet = result_file.worksheets.detect do |ws|
      #   ws.sheet_name.downcase.strip == dest_ws_name.downcase
      # end

      dest_transfers.group_by(&:origin_worksheet_index).each do |origin_ws_index, transfers|
        # TODO: Find the worksheet by user-entered worksheet name instead of index
        # origin_worksheet = result_file.worksheets.detect do |ws|
        #   ws.sheet_name.downcase.strip == origin_ws_name.downcase
        # end
        origin_worksheet = origin_file_upload[origin_ws_index]

        transfers.each do |data_transfer|
          dest_cell = dest_worksheet[data_transfer.destination_row][data_transfer.destination_col]
          origin_cell = origin_worksheet[data_transfer.origin_row][data_transfer.origin_col]
          dest_cell.raw_value = origin_cell.value
        end
      end
    end

    result_file
  end
end
