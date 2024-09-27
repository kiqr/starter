# Controller for handling account deletion in the settings
class Accounts::Settings::DeleteController < Accounts::Settings::BaseController
  # Handle the error when trying to delete an account with multiple members
  rescue_from Account::MembersPresentError, with: :account_with_members_error

  before_action do
    # Redirect to the account members page if the current member is not the owner
    redirect_to account_settings_members_path(account_id: current_account) unless current_member.owner?

    # Set the breadcrumbs for the account deletion page in the settings
    add_breadcrumb I18n.t("kiqr.breadcrumbs.settings.accounts.delete.root"), account_settings_delete_path
  end

  # GET /team/:account_id/settings/delete
  # Display the account deletion confirmation page
  def show
  end

  # DELETE /team/:account_id/settings/delete
  # Process the account deletion
  def destroy
    # Attempt to destroy the current account
    current_account.destroy
    # Set a flash message to inform the user that the account has been deleted
    kiqr_flash_message :success, :account_deleted
    # Redirect to the dashboard without an account context
    redirect_to dashboard_path(account_id: nil)
  end

  private

  # Handle the error when trying to delete an account with multiple members
  def account_with_members_error
    # Set a flash message to inform the user that the account cannot be deleted
    kiqr_flash_message :alert, :account_with_members_deletion_error
    # Redirect back to the account deletion page
    redirect_to account_settings_delete_path(account_id: current_account)
  end
end
