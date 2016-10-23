# == Schema Information
#
# Table name: destination_files
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  position   :integer
#  path       :string
#  task_id    :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class DestinationFile < ApplicationRecord
  belongs_to :task
  has_many :data_transfers
end
