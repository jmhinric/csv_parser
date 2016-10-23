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

  def data_transfers_by_column
    data_transfers.group_by(&:origin_col).values.map do |data_transfers|
      DataTransfersPresenter.transfers(data_transfers)
    end
  end

  def param_name
    name.downcase.gsub(' ', '_')
  end
end
