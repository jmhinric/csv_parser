class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @tasks = current_user.tasks
  end
end
