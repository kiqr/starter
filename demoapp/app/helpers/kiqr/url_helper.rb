module Kiqr::UrlHelper
  # Redirect path after sign-in. If the user hasn't completed onboarding, redirect to onboarding.
  def after_sign_in_path_for(resource)
    return user_onboarding_path unless resource.onboarded?

    session.delete(:after_sign_in_path) || dashboard_path
  end

  # Redirect path after sign-out. Always redirect to the root path.
  def after_sign_out_path_for(_resource_or_scope)
    root_path(account_id: nil) # Resets account_id.
  end

  # Redirect path after selecting an account.
  def after_select_account_path(params)
    dashboard_path(params)
  end

  # Redirect path after the onboarding process is completed.
  def after_onboarding_path(user)
    after_sign_in_path_for(user)
  end

  # Check if the current path matches the base path provided, ignoring query parameters.
  def current_base_path?(path)
    request.path.start_with?(path.split("?").first)
  end
end
