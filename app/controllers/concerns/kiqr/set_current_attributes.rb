module Kiqr::SetCurrentAttributes
  extend ActiveSupport::Concern

  included do
    before_action :set_current_attributes, if: -> { user_signed_in? }
  end

  private

  # Set the current user and account based on the request
  def set_current_attributes
    Current.user = current_user
    Current.account = (fetch_account_from_params || current_user&.personal_account)
  end

  def fetch_account_from_params
    return nil unless params[:account_id].present?
    current_user.accounts.find_puid!(params[:account_id])
  end
end
