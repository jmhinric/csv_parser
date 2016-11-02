class DataTransfersController < ApplicationController

  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def index
    # TODO: implement AUTHORIZATION
    @task ||= Task.find(task_params[:id])
  end

  private

  def task_params
    params.require(:id)
    params.permit(:id)
  end
end
