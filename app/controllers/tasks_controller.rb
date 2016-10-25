# == Schema Information
#
# Table name: tasks
#
#  id          :uuid             not null, primary key
#  name        :string           not null
#  description :string
#  user_id     :uuid
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class TasksController < ApplicationController
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token

  TEMPLATE_BASE_PATH = 'lib/assets/templates/'

  def show
    @task = task
  end

  def execute
    unpack_params

    task.origin_files.each do |origin_file|
      origin_file_upload = RubyXL::Parser.parse(send("#{origin_file.name_as_param}_file").open)

      DataTransfersService.execute(
        origin_file: origin_file,
        origin_file_upload: origin_file_upload,
        result_file: result_file_upload
      )
    end

    respond_to do |format|
      format.xlsx {
        send_data result_file_upload.stream.read, {
          type:'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          disposition:'attachment',
          filename: task.destination_files[0].path
        }
      }
    end
  end

  private

  def task
    @task ||= Task
                .includes(origin_files: { data_transfers: :destination_file })
                .find(task_params[:id])
  end

  def result_file_upload
    @result_file_upload ||= RubyXL::Parser.parse(
      send("#{task.destination_files[0].name_as_param}_file").open
    )
  end

  def user_params
    params.require(:user_id)
    params.permit(:user_id)
  end

  def task_params
    params.require(:id)
    params.permit(:id, :user_id)
  end

  def unpack_params
    (task.origin_files + task.destination_files).each do |file|
      file_params_method = "#{file.name_as_param}_params".to_sym
      file_method = "#{file.name_as_param}_file".to_sym

      define_singleton_method (file_params_method) do
        params.require(file.name_as_param)
        params.permit(file.name_as_param)
      end

      define_singleton_method (file_method) do
        send(file_params_method)[file.name_as_param]
      end
    end
  end
end
