class DataTransfer < ApplicationRecord
  belongs_to :origin_file
  belongs_to :destination_file
end
