# Preview all emails at http://localhost:3000/rails/mailers/contact_comment_mailer
class ContactCommentMailerPreview < ActionMailer::Preview
  def new_comment
    ContactCommentMailer.new_comment(ContactComment.first)
  end
end
