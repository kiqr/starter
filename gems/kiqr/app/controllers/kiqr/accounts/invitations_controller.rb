module Kiqr
  module Accounts
    class InvitationsController < KiqrController
      def index
        @invitations = current_account.account_invitations.pending
        @account = current_account
      end

      def new
        @invitation = current_account.account_invitations.new
      end

      def create
        @invitation = current_account.account_invitations.new(invitation_params)

        if @invitation.valid?
          Kiqr::Services::Invitations::Create.call!(invitation: @invitation, user: current_user)
          kiqr_flash_message(:notice, :invitation_sent, email: @invitation.email)
          redirect_to account_invitations_path(account_id: current_account)
        else
          render :new, status: :unprocessable_entity
        end
      end

      def destroy
        @invitation = current_account.account_invitations.find_puid!(params[:id])
        Kiqr::Services::Invitations::Destroy.call!(invitation: @invitation, user: current_user)
        kiqr_flash_message(:notice, :invitation_destroyed)
        redirect_to account_invitations_path
      end

      private

      def invitation_params
        params.require(:account_invitation).permit(:email)
      end
    end
  end
end
