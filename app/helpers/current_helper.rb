module CurrentHelper
  # Get the current account
  def current_account
    Current.account
  end

  # Check if the user is onboarded
  def onboarded?
    current_user&.onboarded?
  end

  # Get the personal account of the user
  def personal_account
    current_user&.personal_account
  end

  # This checks if the current path contains the string path provided.
  # Allowing for more flexibility than current_page?(path).
  #
  # Example:
  #   current_base_path?(edit_two_factor_path) will return true if the current path is '/users/two-factor/setup'
  def current_base_path?(path)
    request.path.include?(path)
  end
end
