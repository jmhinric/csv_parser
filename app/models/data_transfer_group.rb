# == Schema Information
#
# Table name: data_transfer_groups
#
#  id             :uuid             not null, primary key
#  from_type      :integer
#  to_type        :integer
#  origin_file_id :uuid
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class DataTransferGroup < ApplicationRecord
  belongs_to :origin_file
  has_many :data_transfers

  enum from_type: %i(single row column), _suffix: true
  enum to_type:   %i(single row column), _suffix: true
end
