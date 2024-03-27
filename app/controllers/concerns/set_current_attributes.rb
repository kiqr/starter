module SetCurrentAttributes
  extend ActiveSupport::Concern

  included do
    before_action do
      Current.user = current_user
      Current.account = (fetch_account_from_params || current_user&.personal_account) if user_signed_in?
    end
  end

  private

  def fetch_account_from_params
    return nil unless params[:account_id].present?
    current_user.accounts.find_puid!(params[:account_id])
  end
end
