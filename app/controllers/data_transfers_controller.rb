# == Schema Information
#
# Table name: data_transfers
#
#  id             :uuid             not null, primary key
#  origin_file_id :uuid
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  type           :string
#

# TODO: implement AUTHORIZATION
class DataTransfersController < ApplicationController

  before_action :authenticate_user!
  before_action :load_template, only: [:index, :new, :create, :update, :destroy]
  before_action :load_origin_file, only: [:new, :create]
  before_action :load_new_data_transfer, only: :create
  before_action :load_data_transfer, only: [:update, :destroy]

  skip_before_filter :verify_authenticity_token

  attr_reader :template, :origin_file, :data_transfer

  # TODO: refactor to use jbuilder
  def index
    render(component: 'DataTransferIndex', props: {
      template: React.camelize_props(template.as_json(only: [:id, :name, :description])),
      originFiles: React.camelize_props(origin_files_as_json(template.origin_files)),
      notice: flash[:notice],
      alert: flash[:alert]
    })
  end

  def create
    ActiveRecord::Base.transaction do
      origin_file.data_transfers << data_transfer
      if origin_file.valid? && data_transfer.valid?
        origin_file.save!
        flash[:notice] = "Successfully saved!"
      else
        flash[:alert] = "The data transfer could not be saved. #{data_transfer.errors.messages}"
      end
    end

    redirect_to template_data_transfers_path(template)
  end

  def update
    ocr = data_transfer.origin_cell_range
    ocr.worksheet_index = origin_cell_range_param['worksheet_index']
    ocr.begin_value = origin_cell_range_param['begin_value']
    ocr.end_value = origin_cell_range_param['end_value']

    dcr = data_transfer.destination_cell_range
    dcr.worksheet_index = destination_cell_range_param['worksheet_index']
    dcr.begin_value = destination_cell_range_param['begin_value']
    dcr.end_value = destination_cell_range_param['end_value']

    if (ocr.save! && dcr.save!)
      flash[:notice] = "Successfully updated!"
    else
      flash[:alert] = "The data transfer could not be updated. #{data_transfer.errors.messages}"
    end
    redirect_to template_data_transfers_path(template)
  end


  def destroy
    if data_transfer.destroy!
      flash[:notice] = "Successfully deleted!"
    else
      flash[:alert] = "The data transfer could not be deleted. #{data_transfer.errors.messages}"
    end
    redirect_to template_data_transfers_path(template)
  end

  private

  def resource_params
    params.permit(
      :template_id,
      :origin_file_id,
      data_transfer: [
        :id,
        :type,
        origin_cell_range: [:worksheet_index, :begin_value, :end_value],
        destination_cell_range: [:worksheet_index, :begin_value, :end_value]
      ]
    )
  end

  def origin_cell_range_param
    resource_params['data_transfer']['origin_cell_range']
  end

  def destination_cell_range_param
    resource_params['data_transfer']['destination_cell_range']
  end

  def data_transfer_params
    resource_params['data_transfer']
  end

  def load_template
    @template ||= Template.find(resource_params[:template_id])
  end

  def load_origin_file
    @origin_file ||= OriginFile.find(resource_params[:origin_file_id])
  end

  def load_data_transfer
    @data_transfer ||= DataTransfer.find(params.permit(:id)[:id])
  end

  def load_new_data_transfer
    @data_transfer ||= DataTransfer.new(
      origin_file: origin_file,
      origin_cell_range: origin_cell_range,
      destination_cell_range: destination_cell_range,
      type: "#{data_transfer_params['type'].capitalize}DataTransfer"
    )
  end

  def origin_cell_range
    ocr = OriginCellRange.new(data_transfer_params['origin_cell_range'])
    ocr.begin_value.upcase!
    ocr.end_value.try(:upcase!)
    ocr
  end

  def destination_cell_range
    dcr = DestinationCellRange.new(data_transfer_params['destination_cell_range'])
    dcr.begin_value.upcase!
    dcr.end_value.try(:upcase!)
    dcr
  end

  def origin_files_as_json(origin_files)
    origin_files.map do |origin_file|
      {
        id: origin_file.id,
        name: origin_file.name,
        data_transfers: origin_file.data_transfers.map do |data_transfer|
          {
            id: data_transfer.id,
            type: data_transfer.transfer_type,
            origin_cell_range: data_transfer.origin_cell_range
              .as_json(only: [:worksheet_index, :begin_value, :end_value]),
            destination_cell_range: data_transfer.destination_cell_range
              .as_json(only: [:worksheet_index, :begin_value, :end_value])
          }
        end
      }
    end
  end
end
