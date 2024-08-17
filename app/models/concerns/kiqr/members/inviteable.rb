module Kiqr
  module Members
    module Inviteable
      extend ActiveSupport::Concern

      included do
        before_save :auto_accept_when_member
        belongs_to  :invited_by, class_name: "Member", required: false
        has_secure_token :invitation_token # Invitation token to generate a unique invitation link.
      end

      def accept_invitation_for_user(user_id)
        update(invitation_accepted_at: Time.current, user_id: user_id)
        # @todo: Send welcome email to the user.
      end

      def decline_invitation
        destroy
        # @todo: Send email to the inviter that the user has declined the invitation.
      end

      def self.find_by_invitation_token(token)
        includes(:account, invited_by: :user).references(:account, invited_by: :user).find_by(invitation_token: token)
      end

      # Set the invitation accepted automatically time when user creates a team.
      # @todo: check if this is really needed.
      def auto_accept_when_member
        self.invitation_accepted_at = Time.current if self.owner? && self.invitation_email.nil?
      end

      def pending_invitation?
        self.user_id.nil? && self.invitation_accepted_at.nil? && self.invitation_token.present?
      end
    end
  end
end
