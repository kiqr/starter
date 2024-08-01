class User < ApplicationRecord
  # Default devise modules.
  devise :registerable, :recoverable, :rememberable, :validatable, :confirmable, :lockable, :timeoutable, :trackable

  # Enable two-factor authentication.
  devise :two_factor_authenticatable

  # User belongs to a personal account.
  belongs_to :personal_account, class_name: "Account", optional: true, dependent: :destroy
  validates_associated :personal_account
  accepts_nested_attributes_for :personal_account

  # User can have many team accounts.
  has_many :account_users, dependent: :destroy
  has_many :accounts, through: :account_users

  validates :email, presence: true, uniqueness: true
  validates :time_zone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }
  validates :locale, inclusion: { in: Kiqr::Config.available_locales.map(&:to_s) }

  # OmniAuth identities for logins using external providers
  has_many :omniauth_identities, dependent: :destroy

  # Get the user's full name from their personal account.
  delegate :name, to: :personal_account

  def onboarded?
    personal_account.present? && personal_account.persisted?
  end

  def otp_uri
    issuer = Kiqr::Config.app_name
    otp_provisioning_uri(email, issuer: issuer)
  end

  def reset_otp_secret!
    update!(
      otp_secret: User.generate_otp_secret,
      otp_required_for_login: false,
      consumed_timestep: nil,
      otp_backup_codes: nil
    )
  end

  def cancel_pending_email_change!
    update!(unconfirmed_email: nil, confirmation_sent_at: nil)
  end
end
