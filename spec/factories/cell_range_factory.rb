FactoryGirl.define do
  factory :cell_range do
    worksheet_index { (0..10).to_a.sample }
    begin_value { ('a'..'z').to_a.sample + (0..50).to_a.sample.to_s }
    end_value { ('a'..'z').to_a.sample + (0..50).to_a.sample.to_s }
    data_transfer { create(:range_data_transfer) }

    factory :single_origin_cell_range do
      begin_value { ('a'..'z').to_a.sample + (0..50).to_a.sample.to_s }
      end_value { nil }
      data_transfer { create(:single_data_transfer) }
    end

    factory :single_destination_cell_range do
      begin_value { ('a'..'z').to_a.sample + (0..50).to_a.sample.to_s }
      end_value { nil }
      data_transfer { create(:single_data_transfer) }
    end

    factory :range_origin_cell_range do
      begin_value { ('a'..'z').to_a.sample + (0..50).to_a.sample.to_s }
      end_value { ('a'..'z').to_a.sample + (0..50).to_a.sample.to_s }
      data_transfer { create(:range_data_transfer) }
    end

    factory :range_destination_cell_range do
      begin_value { ('a'..'z').to_a.sample + (0..50).to_a.sample.to_s }
      end_value { ('a'..'z').to_a.sample + (0..50).to_a.sample.to_s }
      data_transfer { create(:range_data_transfer) }
    end
  end
end
