module Kiqr
  module Models
    module Member
      extend ActiveSupport::Concern
      include PublicUid::ModelConcern

      included do
        before_save :auto_accept_when_member
        before_destroy :prevent_owner_deletion

        belongs_to :invited_by, class_name: "Member", required: false
        belongs_to :user, required: false
        belongs_to :account

        validates :invitation_email, uniqueness: { scope: :account_id }, allow_blank: true
        validates :invitation_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { user_id.nil? }
        validates :invitation_token, presence: true, uniqueness: { scope: :account_id }

        scope :pending, -> { where(user_id: nil, invitation_accepted_at: nil) }
        scope :accepted, -> { where.not(user_id: nil).where.not(invitation_accepted_at: nil) }

        has_secure_token :invitation_token # Invitation token to generate a unique invitation link.
      end

      def name
        user_attribute(:name)
      end

      def email
        user_attribute(:email)
      end

      def accept_invitation_for_user(user_id)
        update(invitation_accepted_at: Time.current, user_id: user_id)
        # @todo: Send welcome email to the user.
      end

      def decline_invitation
        destroy
        # @todo: Send email to the inviter that the user has declined the invitation.
      end

      def pending_invitation?
        self.user_id.nil? && self.invitation_accepted_at.nil? && self.invitation_token.present?
      end

      module ClassMethods
        def find_by_invitation_token(token)
          includes(:account, invited_by: :user).references(:account, invited_by: :user).find_by(invitation_token: token)
        end
      end

      protected

      # Set the invitation accepted automatically time when user creates a team.
      # @todo: check if this is really needed.
      def auto_accept_when_member
        self.invitation_accepted_at = Time.current if self.owner? && self.invitation_email.nil?
      end

      # Return the user's attribute or the invitation attribute if the user hasn't accepted the invitation yet.
      def user_attribute(attribute)
        user.present? ? user.send(attribute) : invitation_email
      end

      # Prevent the deletion of account owners.
      def prevent_owner_deletion
        raise Kiqr::Errors::AccountOwnerDeletionError if owner?
      end
    end
  end
end
