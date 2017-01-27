class ContactCommentMailer < ApplicationMailer
  default from: 'Evergreen Comments <comments@evergreendataservices.com>'

  def new_comment(contact_comment)
    @contact_comment = contact_comment
    mail(
      to: 'John Hinrichs <jmhinric@gmail.com>',
      subject: 'Evergreen Data Services - New Comment'
    )
  end
end
