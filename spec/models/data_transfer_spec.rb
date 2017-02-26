require 'rails_helper'

RSpec.describe DataTransfer, type: :model do
  it { is_expected.to belong_to :data_transfer_group }
end
