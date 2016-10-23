# == Schema Information
#
# Table name: data_transfers
#
#  id                          :uuid             not null, primary key
#  origin_row                  :integer          not null
#  origin_col                  :integer          not null
#  destination_row             :integer          not null
#  destination_col             :integer          not null
#  origin_worksheet_index      :integer          default(0), not null
#  destination_worksheet_index :integer          not null
#  origin_file_id              :uuid
#  destination_file_id         :uuid
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#

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
