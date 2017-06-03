FactoryGirl.define do
  factory :origin_file do
    name { Faker::Lorem.word }

    template { create(:template) }
  end
end
