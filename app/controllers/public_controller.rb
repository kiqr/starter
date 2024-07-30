# => Public controller
# This controller is used to render the landing page of the application
# This is the first page that the user will see when they visit the application
# The landing page will have a brief description of the application and the features
# The user can then sign up or login to the application
class PublicController < ApplicationController
  # Don't redirect to sign in page if user is not logged in
  skip_before_action :authenticate_user!

  # => Landing page
  # This method is used to render the landing page of the application
  # Edit the view file: app/views/public/landing_page.html.erb
  def landing_page
  end
end
