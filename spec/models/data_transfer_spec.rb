require 'rails_helper'

RSpec.describe DataTransfer, type: :model do
  it { is_expected.to belong_to :origin_file }
  it { is_expected.to have_one :origin_cell_range }
  it { is_expected.to have_one :destination_cell_range }
end
