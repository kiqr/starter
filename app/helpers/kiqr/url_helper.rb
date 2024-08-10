module Kiqr::UrlHelper
  # Override the method to change the sign-in redirect path
  def after_sign_in_path_for(resource)
    if session[:after_sign_in_path].present?
      session.delete(:after_sign_in_path)
    else
      dashboard_path
    end
  end

  # Override the method to change the sign-out redirect path
  def after_sign_out_path_for(resource_or_scope)
    # Generate the root path without default URL options
    uri = URI.parse(root_url)
    uri.query = nil # Remove any query parameters
    uri.to_s
  end

  # Where to redirect after selecting an account.
  def after_select_account_path(params)
    dashboard_path(params)
  end

  # Where to redirect after the onboarding process is completed.
  def after_onboarding_path(user)
    after_sign_in_path_for(user)
  end

  # This checks if the current path contains the string path provided.
  # Allowing for more flexibility than current_page?(path).
  #
  # Example:
  #   current_base_path?(edit_two_factor_path) will return true if the current path is '/users/two-factor/setup'
  def current_base_path?(path)
    path = path.split("?").first # Strip query parameters from path.

    request.path.include?(path)
  end
end
