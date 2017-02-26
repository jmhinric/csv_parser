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
  has_many :data_transfers

  def transfers_by_column_and_destination_worksheet
    data_transfers
      .group_by(&:origin_col).values.map do |data_transfers|
        data_transfers.group_by(&:destination_worksheet_index).values
        .map { |data_transfers| DataTransfersPresenter.transfers(data_transfers) }
      end
  end

  def transfers_by_destination_worksheet
    data_transfers.group_by(&:destination_worksheet_index)
  end

  def param_name
    "origin_#{name.downcase.gsub(' ', '_')}_file".to_sym
  end
end
