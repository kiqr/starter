class User < ApplicationRecord
  include Kiqr::Users::Authenticatable
  include Kiqr::Users::TwoFactorAuthenticatable
  include Kiqr::Users::Omniauthable
  include Kiqr::Users::HasPersonalAccount
  include Kiqr::Users::Teamable

  # Get the user's full name from their personal account.
  delegate :name, to: :personal_account

  # => Model validations
  validates :email, presence: true, uniqueness: true
  validates :time_zone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }
  validates :locale, inclusion: { in: Kiqr::Config.available_locales.map(&:to_s) }

  attr_accessor :skip_password_validation  # virtual attribute to skip password validation while saving

  protected

  def password_required?
    return false if skip_password_validation
    super
  end

  # Include any custom methods here
end
