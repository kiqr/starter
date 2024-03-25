class ApplicationController < ActionController::Base
  include Accounts

  private

  # Redirect to dashboard after sign in
  def after_sign_in_path_for(resource)
    dashboard_path
  end
end
