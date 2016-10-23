class DataTransfersPresenter
  Cell = Struct.new(:row, :col) do
    COLUMNS = ([''] + ('a'..'e').to_a).map do |prefix|
      ('a'..'z').to_a.map { |l| prefix + l }
    end.flatten

    def to_s
      "#{COLUMNS[col].upcase}#{(row + 1)}"
    end
  end

  attr_reader :data_transfers

  def initialize(data_transfers)
    @data_transfers = data_transfers
  end

  def self.transfers(*args)
    new(*args).transfers
  end

  def transfers
    data_transfers.map do |data_transfer|
      {
        from: Cell.new(data_transfer.origin_row, data_transfer.origin_col).to_s,
        to: Cell.new(data_transfer.destination_row, data_transfer.destination_col).to_s,
        origin_file: data_transfer.origin_file_name,
        origin_worksheet: data_transfer.origin_worksheet_name,
        destination_file: data_transfer.destination_file_name,
        destination_worksheet: data_transfer.destination_worksheet_name
      }
    end
  end
end
