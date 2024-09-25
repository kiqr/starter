module Kiqr
  module SetCurrentRequestDetails
    extend ActiveSupport::Concern

    included do
      before_action :set_user_and_account_atributes
    end

    protected

    # Set the current user and account based on the request.
    # This method is called before every action in the controller
    # and sets the current user and account based on the request.
    def set_user_and_account_atributes
      return unless user_signed_in?

      Current.user = current_user
      Current.account ||= fetch_account_from_params || current_user&.personal_account
    end

    # Fetch the account from the request params
    def fetch_account_from_params
      return nil unless params[:account_id].present?

      current_user.accounts.find_puid!(params[:account_id])
    rescue PublicUid::RecordNotFound
      head :forbidden
    end
  end
end
