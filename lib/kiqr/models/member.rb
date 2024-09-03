module Kiqr
  module Models
    module Member
      extend ActiveSupport::Concern
      include PublicUid::ModelConcern

      included do
        # Callbacks
        before_save :auto_accept_when_member
        before_destroy :prevent_owner_deletion

        # Associations
        belongs_to :invited_by, class_name: "Member", required: false
        belongs_to :user, required: false
        belongs_to :account

        # Validations
        validates :invitation_email, uniqueness: { scope: :account_id }, allow_blank: true
        validates :invitation_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { user_id.nil? }
        validates :invitation_token, presence: true, uniqueness: { scope: :account_id }

        # Scopes
        scope :pending, -> { where(user_id: nil, invitation_accepted_at: nil) }
        scope :accepted, -> { where.not(user_id: nil).where.not(invitation_accepted_at: nil) }

        # Secure token for invitation
        has_secure_token :invitation_token
      end

      # Virtual attribute to skip owner deletion validation while destroying a team.
      attr_accessor :skip_prevent_owner_deletion

      # Returns the name of the user or the invitation email if the user hasn't accepted yet
      def name
        user_attribute(:name)
      end

      # Returns the email of the user or the invitation email if the user hasn't accepted yet
      def email
        user_attribute(:email)
      end

      # Accepts the invitation for a given user
      # @param user_id [Integer] The ID of the user accepting the invitation
      def accept_invitation_for_user(user_id)
        update(invitation_accepted_at: Time.current, user_id: user_id)
        # @todo: Send welcome email to the user.
      end

      # Declines the invitation by destroying the member record
      def decline_invitation
        destroy
        # @todo: Send email to the inviter that the user has declined the invitation.
      end

      # Checks if the invitation is pending
      # @return [Boolean] true if the invitation is pending, false otherwise
      def pending_invitation?
        self.user_id.nil? && self.invitation_accepted_at.nil? && self.invitation_token.present?
      end

      module ClassMethods
        # Finds a member by their invitation token
        # @param token [String] The invitation token
        # @return [Member, nil] The member with the given token, or nil if not found
        def find_by_invitation_token(token)
          includes(:account, invited_by: :user).references(:account, invited_by: :user).find_by(invitation_token: token)
        end
      end

      protected

      # Sets the invitation accepted time automatically when a user creates a team
      # @todo: check if this is really needed.
      def auto_accept_when_member
        self.invitation_accepted_at = Time.current if self.owner? && self.invitation_email.nil?
      end

      # Returns the user's attribute or the invitation attribute if the user hasn't accepted the invitation yet
      # @param attribute [Symbol] The attribute to retrieve
      # @return [String] The value of the attribute
      def user_attribute(attribute)
        user.present? ? user.send(attribute) : invitation_email
      end

      # Prevents the deletion of account owners
      # @raise [Kiqr::Errors::AccountOwnerDeletionError] If trying to delete an owner without skipping the validation
      def prevent_owner_deletion
        raise Kiqr::Errors::AccountOwnerDeletionError if owner? && !skip_prevent_owner_deletion
      end
    end
  end
end
