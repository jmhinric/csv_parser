class OriginFilesController < ApplicationController
  before_action :load_template, only: [:new, :create]
  before_action :load_origin_file, only: :create

  def new
    render(component: 'OriginFileNew', props: {
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

  private

  def load_template
    @template = Template.find(params.permit(:template_id)[:template_id])
  end

  def new_origin_file_params
    params.require(:origin_file).permit(:name).slice(:name)
  end

  def load_origin_file
    new_position = (@template.origin_files.pluck(:position).max || 0) + 1
    @origin_file = OriginFile.new(new_origin_file_params.merge(position: new_position))
  end
end
