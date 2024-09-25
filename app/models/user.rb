class User < ApplicationRecord
  # Register Devise modules
  devise :registerable, :recoverable, :rememberable, :validatable,
          :confirmable, :lockable, :timeoutable, :trackable, :omniauthable

  # Using the "devise-two-factor" gem
  devise :two_factor_authenticatable

  # Omniauth identities for social/external logins
  has_many :omniauth_identities, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :accounts, through: :members

  # Personal account
  belongs_to :personal_account, class_name: "Account", optional: true, dependent: :destroy
  accepts_nested_attributes_for :personal_account
  validates_associated :personal_account

  # Validation of KIQR fields
  validates :email, presence: true, uniqueness: true
  validates :time_zone, inclusion: { in: -> { ActiveSupport::TimeZone.all.map(&:name) } }
  validates :locale, inclusion: { in: -> { I18n.available_locales.map(&:to_s) } }

  # Virtual attribute to skip password validation while saving
  attr_accessor :skip_password_validation

  # Get the user's full name from their personal account.
  delegate :name, to: :personal_account

  # Generate the user's OTP provisioning URI.
  def otp_uri
    issuer = Kiqr::Config.app_name
    otp_provisioning_uri(email, issuer: issuer)
  end

  # Check if the user has been onboarded successfully.
  def onboarded?
    personal_account&.persisted?
  end

  # Alternative to the devise update_with_password method to
  # allow users to add a password without providing their current password.
  def create_password(params)
    params.delete(:current_password)
    result = update(params)
    clean_up_passwords
    result
  end

  # Reset unconfirmed email and confirmation sent at.
  # This is useful when a user cancels their email change.
  def cancel_pending_email_change!
    update!(unconfirmed_email: nil, confirmation_sent_at: nil)
  end

  # Helper method to allow for other two-factor methods
  # to be added in the future.
  def two_factor_enabled?
    otp_required_for_login?
  end

  # Reset the user's OTP secret and disable two-factor authentication.
  def reset_otp_secret!
    update!(
      otp_secret: generate_otp_secret,
      otp_required_for_login: false,
      consumed_timestep: nil,
      otp_backup_codes: nil
    )
  end

  protected

  # Used by Devise to check if the user's password is required.
  # This must be defined inside the included block since the
  # original method is protected.
  def password_required?
    return false if skip_password_validation
    super
  end

  # Generate a random OTP secret.
  def generate_otp_secret(otp_secret_length = Devise.otp_secret_length)
    ROTP::Base32.random_base32(otp_secret_length)
  end
end
