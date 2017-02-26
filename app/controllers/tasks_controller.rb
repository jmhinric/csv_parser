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
  include Exceptions

  # TODO look more into user authentication/authorization
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def new
    render(component: 'TaskNew', props: {
      task: Task.new,
      userId: current_user.id,
      notice: flash[:notice],
      alert: flash[:alert]
    })
  end

  def create
    begin
      @task = current_user.tasks.create(new_task_params)
    rescue => e
      flash[:alert] = "Oops! Something went wrong.  Please contact support."
    end

    redirect_to user_path(current_user)
  end

  def show
    @task = task
  end

  def execute
    begin
      unpack_params

      task.origin_files.each do |origin_file|
        DataTransfersService.execute(
          origin_file: origin_file,
          origin_file_upload: RubyXL::Parser.parse(send(origin_file.param_name).open),
          result_file: result_file_upload
        )
      end

      respond_to do |format|
        format.xlsx {
          send_data result_file_upload.stream.read, {
            type:'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            disposition:'attachment',
            filename: task.filename + '.xlsx'
          }
        }
      end
    rescue Exceptions::MissingParamError => e
      flash[:alert] = e.message
      redirect_to user_task_path(current_user, task)
    rescue => e
      flash[:alert] = "Oops! Something went wrong.  Please contact support."
      redirect_to user_task_path(current_user, task)
    end
  end

  private

  def task
    @task ||= Task
      .includes(origin_files: :data_transfers)
      .find(task_params[:id])
  end

  def result_file_upload
    @result_file_upload ||= RubyXL::Parser.parse(destination_file.open)
  end

  def task_params
    params.require(:id)
    params.permit(:id, :user_id)
  end

  def new_task_params
    params.require(:task).permit(:name, :description)
  end

  def destination_file_params
    params.require(task.file_param_name)
    params.permit(task.file_param_name)
  end

  def destination_file
    destination_file_params[task.file_param_name]
  end

  def unpack_params
    task.origin_files.map(&:param_name).each do |param_name|
      unless params[param_name]
        raise Exceptions::MissingParamError, "#{file.name} file was missing."
      end
      raise Exceptions::MissingParamError, "#{task.name} file was missing." unless destination_file

      params_method = "#{param_name}_params".to_sym

      define_singleton_method (params_method) do
        params.require(param_name)
        params.permit(param_name)
      end

      define_singleton_method (param_name) do
        send(params_method)[param_name]
      end
    end
  end
end
