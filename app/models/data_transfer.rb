class DataTransfer < ApplicationRecord
  belongs_to :origin_file
  belongs_to :destination_file

  def destination_file_name
    destination_file.name
  end

  def destination_worksheet_name
    (destination_worksheet_index + 1).to_s
  end
end
