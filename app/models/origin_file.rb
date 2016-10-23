class OriginFile < ApplicationRecord
  belongs_to :task
  has_many :data_transfers
end
