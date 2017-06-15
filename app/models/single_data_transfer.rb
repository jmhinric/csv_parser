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

class SingleDataTransfer < DataTransfer
  def transfer_type
    'single'
  end
end
