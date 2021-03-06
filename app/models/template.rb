# == Schema Information
#
# Table name: templates
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  description :string
#  user_id     :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Template < ApplicationRecord
  belongs_to :user
  has_many :origin_files, dependent: :destroy

  def filename
    name.downcase.gsub(' ', '_')
  end

  def file_param_name
    "dest_#{filename}_file".to_sym
  end
end
