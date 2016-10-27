# == Schema Information
#
# Table name: origin_files
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  position   :integer
#  task_id    :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OriginFile < ApplicationRecord
  belongs_to :task
  has_many :data_transfers

  def transfers_by_column_and_destination_worksheet
    data_transfers
      .group_by(&:origin_col).values.map do |data_transfers|
        data_transfers.group_by(&:destination_worksheet_index).values
        .map do |data_transfers|
          DataTransfersPresenter.transfers(data_transfers)
        end
      end
  end

  def transfers_by_destination_worksheet
    data_transfers.group_by(&:destination_worksheet_index)
  end

  def name_as_param
    "origin_#{name.downcase.gsub(' ', '_')}".to_sym
  end
end
