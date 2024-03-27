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
end
