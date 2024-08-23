class KiqrController < ApplicationController
  def kiqr_flash_message(type, message, **kwargs)
    flash[type] = I18n.t("flash_messages.#{message}", **kwargs)
  end

  def kiqr_flash_message_now(type, message, **kwargs)
    flash.now[type] = I18n.t("flash_messages.#{message}", **kwargs)
  end

  protected

  # Redirect path after sign-in. If the user hasn't completed onboarding, redirect to onboarding.
  def after_sign_in_path_for(resource)
    return onboarding_path unless resource.onboarded?

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
end
