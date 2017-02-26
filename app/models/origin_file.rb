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
  has_many :data_transfer_groups

  def transfers_by_column_and_destination_worksheet
    data_transfer_groups.map do |data_transfer_group|
      data_transfer_group.data_transfers.group_by(&:destination_worksheet_index).values
        .map { |data_transfers| DataTransfersPresenter.transfers(data_transfers) }
    end
  end

  def transfers_by_destination_worksheet
    data_transfers.group_by(&:destination_worksheet_index)
  end

  def param_name
    "origin_#{name.downcase.gsub(' ', '_')}_file".to_sym
  end

  private

  def data_transfers
    data_transfer_groups.flat_map(&:data_transfers)
  end
end
