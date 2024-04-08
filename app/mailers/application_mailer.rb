class ApplicationMailer < ActionMailer::Base
  default from: Kiqr::Config.default_from_email
  layout "mailer"
end
