require 'rails_helper'

RSpec.describe ContactComment, type: :model do
  [:name, :email, :message].each do |attr|
    it { is_expected.to validate_presence_of(attr) }
  end

  it { is_expected.to_not allow_value('test').for(:email) }
  it { is_expected.to allow_value('test@test.com').for(:email) }
end
