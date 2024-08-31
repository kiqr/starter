class PublicController < ApplicationController
  # Don't require authentication for the landing page.
  skip_before_action :authenticate_user!
  skip_before_action :ensure_onboarded

  # => Landing page
  # This method is used to render the landing page of the application
  # Edit the view file: app/views/public/landing_page.html.erb
  def landing_page
  end
end
