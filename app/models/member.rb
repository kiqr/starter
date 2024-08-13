class Member < ApplicationRecord
  include PublicUid::ModelConcern
  include Kiqr::Members::ActsAsMember
  include Kiqr::Members::Inviteable

  # => Scopes
  scope :pending, -> { where(user_id: nil) }
  scope :accepted, -> { where.not(user_id: nil).where.not(invitation_accepted_at: nil) }

  # => Validations
  validates :invitation_email, uniqueness: { scope: :account_id }, allow_blank: true
  validates :invitation_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { user_id.nil? }
  validates :invitation_token, presence: true, uniqueness: { scope: :account_id }

  # Name of the user or invitation email if user hasn't accepted the invitation yet.
  def name
    user.present? ? user.name : invitation_email
  end

  # Email of the user or invitation email if user hasn't accepted the invitation yet.
  def email
    user.present? ? user.email : invitation_email
  end

  # Prevent the deletion of account owners.
  def destroy
    raise Kiqr::Errors::DeleteTeamOwnerError if owner?
    super
  end
end
