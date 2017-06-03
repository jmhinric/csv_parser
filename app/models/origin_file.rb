# == Schema Information
#
# Table name: origin_files
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  position    :integer
#  template_id :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class OriginFile < ApplicationRecord
  belongs_to :template
  has_many :data_transfers, validate: true
  has_many :single_data_transfers, validate: true, class_name: 'SingleDataTransfer'
  has_many :range_data_transfers, validate: true, class_name: 'RangeDataTransfer'

  def transfers_by_destination_worksheet
    data_transfers.flat_map(&:cells).group_by(&:destination_worksheet_index)
  end

  def param_name
    "origin_#{name.downcase.gsub(' ', '_')}_file".to_sym
  end
end
