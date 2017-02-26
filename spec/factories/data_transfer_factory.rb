FactoryGirl.define do
  factory :data_transfer do
    origin_file { create(:origin_file) }

    factory :single_data_transfer, class: SingleDataTransfer do
    end

    factory :range_data_transfer, class: RangeDataTransfer do
    end
  end
end
