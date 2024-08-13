module Kiqr
  module Members
    module Inviteable
      extend ActiveSupport::Concern

      included do
        before_save :set_invitation_accepted_at
        belongs_to :invited_by, class_name: "Member", required: false

        # Invitation token to generate a unique invitation link.
        has_secure_token :invitation_token
      end


      def send_invitation_email
        # update(invitation_sent_at: Time.current)
        # TODO: Send invitation email
      end

      # Set the invitation accepted automatically time when user creates a team.
      def set_invitation_accepted_at
        self.invitation_accepted_at = Time.current if self.owner? && self.invitation_email.nil?
      end
    end
  end
end
