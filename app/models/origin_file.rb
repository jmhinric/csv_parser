require_relative '../presenters/data_transfers_presenter'

class OriginFile < ApplicationRecord
  belongs_to :task
  has_many :data_transfers

  def data_transfers_by_column
    data_transfers.group_by(&:origin_col).values.map do |data_transfers|
      DataTransfersPresenter.transfers(data_transfers)
    end
  end
end
