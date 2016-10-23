class TasksController < ApplicationController
  before_action :authenticate_user!

  def show
    @task = Task.includes(origin_files: { data_transfers: :destination_file }).find(task_id)
  end

  private

  def user_params
    params.require(:user_id)
    params.permit(:user_id)
  end

  def task_params
    params.require(:id)
    params.permit(:id, :user_id)
  end

  def task_id
    task_params[:id]
  end
end
