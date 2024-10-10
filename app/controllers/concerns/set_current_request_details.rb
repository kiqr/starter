module SetCurrentRequestDetails
  extend ActiveSupport::Concern

  included do
    before_action :set_user_and_account_atributes
    before_action :redirect_with_account_parameter
  end

  protected

  # Set the current user and account based on the request.
  # This method is called before every action in the controller
  # and sets the current user and account based on the request.
  # @return [void]
  def set_user_and_account_atributes
    return unless user_signed_in?

    Current.user = current_user
    Current.account ||= fetch_account_from_params || fallback_account
  end

  # Redirect to the current url but with account_id in the url if the account_id is missing
  # @return [Redirect] redirect to the current url with account_id
  def redirect_with_account_parameter
    if account_scope? && Current.account && params[:account_id].blank?
      redirect_to url_for(account_id: Current.account.public_uid)
    end
  end

  # Fetch the account from the request params
  # @return [Account, nil] the account or nil if not found
  def fetch_account_from_params
    return nil unless params[:account_id].present?

    current_user.accounts.find_puid!(params[:account_id])
  rescue PublicUid::RecordNotFound
    head :forbidden
  end

  # First account of the user
  # @return [Account, nil] the first account of the user
  def fallback_account
    current_user.accounts.first
  end

  private

  # Check if we are inside an account scope
  def account_scope?
    @is_account_scope
  end
end
