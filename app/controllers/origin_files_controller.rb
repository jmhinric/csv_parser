# TODO: implement AUTHORIZATION
class OriginFilesController < ApplicationController
  before_action :load_template, only: [:new, :create, :edit, :update, :destroy]
  before_action :load_new_origin_file, only: :create
  before_action :load_origin_file, only: [:edit, :update, :destroy]

  def new
    render(component: 'OriginFileForm', props: {
      template: @template,
      originFile: OriginFile.new,
      notice: flash[:notice],
      alert: flash[:alert]
    })
  end

  def create
    @template.origin_files << @origin_file
    @template.save!

    redirect_to template_path(@template)
  rescue => e
    flash[:alert] = "Oops! Something went wrong.  Please contact support."
    redirect_to template_path(@template)
  end

  def edit
    render(component: 'OriginFileForm', props: {
      template: @template,
      originFile: @origin_file,
      notice: flash[:notice],
      alert: flash[:alert]
    })
  end

  def update
    if @origin_file.update!(name: origin_file_params['name'])
      flash[:notice] = "Successfully updated!"
    else
      flash[:alert] = "The origin file could not be updated. #{@origin_file.errors.messages}"
    end

    redirect_to template_path(@template)
  end

  def destroy
    if @origin_file.destroy!
      flash[:notice] = "Successfully deleted!"
    else
      flash[:alert] = "The origin file could not be deleted. #{@origin_file.errors.messages}"
    end
    redirect_to template_path(@template)
  end

  private

  def load_template
    @template = Template.find(params.permit(:template_id)[:template_id])
  end

  def origin_file_params
    params.require(:origin_file).permit(:id, :name)
  end

  def load_new_origin_file
    new_position = (@template.origin_files.pluck(:position).max || 0) + 1
    @origin_file = OriginFile.new(origin_file_params.slice(:name).merge(position: new_position))
  end

  def load_origin_file
    @origin_file = OriginFile.find(params.permit(:id)['id'])
  end
end
