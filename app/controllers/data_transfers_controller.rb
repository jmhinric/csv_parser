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
  before_action :load_template, only: [:index, :new]
  before_action :load_origin_file, only: :new
  skip_before_filter :verify_authenticity_token

  # TODO: implement AUTHORIZATION
  def index
  end

  # TODO: implement AUTHORIZATION
  def new
    render(
      component: 'DataTransferNew',
      props: {
        template: @template,
        originFile: @origin_file,
        notice: flash[:notice],
        alert: flash[:alert]
      }
    )
  end

  private

  def resource_params
    params.permit(:id, :origin_file_id)
  end

  def load_template
    @template = Template.find(resource_params[:id])
  end

  def load_origin_file
    @origin_file = OriginFile.find(resource_params[:origin_file_id])
  end
end
