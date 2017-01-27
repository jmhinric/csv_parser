# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# https://sendgrid.com/docs/Integrate/Frameworks/rubyonrails.html
ActionMailer::Base.smtp_settings = {
  :user_name => SENDGRID_USERNAME,
  :password => SENDGRID_PASSWORD,
  :domain => 'evergreendataservices.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
