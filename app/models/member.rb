class Member < ApplicationRecord
  include PublicUid::ModelConcern
  include Kiqr::Members::ActsAsMember
  include Kiqr::Members::Inviteable

  # => Scopes
  scope :pending, -> { where(user_id: nil, invitation_accepted_at: nil) }
  scope :accepted, -> { where.not(user_id: nil).where.not(invitation_accepted_at: nil) }

  # => Validations
  validates :invitation_email, uniqueness: { scope: :account_id }, allow_blank: true
  validates :invitation_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { user_id.nil? }
  validates :invitation_token, presence: true, uniqueness: { scope: :account_id }

  # => Callbacks
  before_destroy :prevent_owner_deletion

  # => User attributes
  def name
    user_attribute(:name)
  end

  def email
    user_attribute(:email)
  end

  private

  # Return the user's attribute or the invitation attribute if the user hasn't accepted the invitation yet.
  def user_attribute(attribute)
    user.present? ? user.send(attribute) : invitation_email
  end

  # Prevent the deletion of account owners.
  def prevent_owner_deletion
    raise "Can't delete team owner" if owner?
  end
end
