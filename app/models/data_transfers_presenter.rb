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
        origin_cell: Cell.new(data_transfer.origin_row, data_transfer.origin_col).to_s,
        destination_cell: Cell.new(data_transfer.destination_row, data_transfer.destination_col).to_s,
        origin_worksheet: (data_transfer.origin_worksheet_index + 1).to_s,
        destination_worksheet: (data_transfer.destination_worksheet_index + 1).to_s
      }
    end
  end
end
