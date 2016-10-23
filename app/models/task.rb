class Task < ApplicationRecord
  belongs_to :user
  has_many :origin_files
  has_many :destination_files
end
