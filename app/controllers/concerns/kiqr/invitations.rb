module Kiqr
  module Invitations
    extend ActiveSupport::Concern

    included do
      before_action :redirect_to_pending_invitation
    end

    def redirect_to_pending_invitation
      if session[:invitation_token] && user_signed_in? && onboarded?
        token = session[:invitation_token]
        reset_invitation_session
        redirect_to user_invitation_path(token: token)
      end
    end

    private

      # Reset the invitation session after the user has accepted or declined the invitation.
      def reset_invitation_session
        session.delete(:invitation_token)
      end
  end
end
