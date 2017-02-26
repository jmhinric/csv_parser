# == Schema Information
#
# Table name: data_transfers
#
#  id                          :uuid             not null, primary key
#  origin_row                  :integer          not null
#  origin_col                  :integer          not null
#  destination_row             :integer          not null
#  destination_col             :integer          not null
#  origin_worksheet_index      :integer          default(0), not null
#  destination_worksheet_index :integer          not null
#  data_transfer_group_id      :uuid
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#

class DataTransfersController < ApplicationController

  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def index
    # TODO: implement AUTHORIZATION
    @template ||= Template.find(template_params[:id])
  end

  private

  def template_params
    params.require(:id)
    params.permit(:id)
  end
end
