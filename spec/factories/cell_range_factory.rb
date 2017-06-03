FactoryGirl.define do
  factory :cell_range do
    worksheet_index { (0..10).to_a.sample }
    begin_value { ('a'..'z').to_a.sample + (0..50).to_a.sample.to_s }
    end_value { ('a'..'z').to_a.sample + (0..50).to_a.sample.to_s }

    factory :single_origin_cell_range, class: OriginCellRange do
      begin_value { ('a'..'z').to_a.sample + (0..50).to_a.sample.to_s }
      end_value { nil }
    end

    factory :single_destination_cell_range, class: DestinationCellRange do
      begin_value { ('a'..'z').to_a.sample + (0..50).to_a.sample.to_s }
      end_value { nil }
    end

    factory :range_origin_cell_range, class: OriginCellRange do
      begin_value { ('a'..'z').to_a.sample + (0..50).to_a.sample.to_s }
      end_value { ('a'..'z').to_a.sample + (0..50).to_a.sample.to_s }
    end

    factory :range_destination_cell_range, class: DestinationCellRange do
      begin_value { ('a'..'z').to_a.sample + (0..50).to_a.sample.to_s }
      end_value { ('a'..'z').to_a.sample + (0..50).to_a.sample.to_s }
    end
  end
end
