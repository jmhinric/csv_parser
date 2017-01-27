FactoryGirl.define do
  factory :task do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    user { create(:user) }
  end
end
