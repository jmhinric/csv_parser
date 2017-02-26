FactoryGirl.define do
  factory :template do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    user { create(:user) }
  end
end
