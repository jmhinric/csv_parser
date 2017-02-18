# == Schema Information
#
# Table name: contact_comments
#
#  id         :uuid             not null, primary key
#  name       :string
#  email      :string
#  message    :text
#  replied    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ContactCommentsController < ApplicationController
  def new
    render(component: 'ContactCommentNew', props: {
      contactComment: ContactComment.new,
      notice: flash[:notice],
      alert: flash[:alert]
    })
  end

  def create
    contact_comment = ContactComment.create!(contact_params)
    ContactCommentMailer.new_comment(contact_comment).deliver

    flash[:notice] = 'We received your comment and will get back to you shortly.  Thank you!'
    redirect_to contact_path

  rescue => e
    Rails.logger.error("#{e.message}\n#{e.backtrace.join("\n")}")

    flash[:alert] = e.message
    redirect_to contact_path
  end

  private

  def contact_params
    params.require(:contact_comment).permit(:name, :email, :message)
  end
end
