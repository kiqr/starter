class ApplicationMailer < ActionMailer::Base
  # Change the default path for mailer views
  prepend_view_path "app/views/mailers"

  # Set the default layout for mailers
  layout "mailer"

  # Set the default from email address
  default from: Kiqr::Config.default_from_email
end
