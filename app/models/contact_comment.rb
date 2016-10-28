# == Schema Information
#
# Table name: contact_comments
#
#  id         :uuid             not null, primary key
#  name       :string
#  email      :string
#  message    :text
#  replied    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContactComment < ApplicationRecord
  validates :name, :email, :message, presence: true
end
