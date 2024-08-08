class User < ApplicationRecord
  include Kiqr::Authenticatable
  include Kiqr::TwoFactorAuthenticatable
  include Kiqr::Omniauthable
  include Kiqr::HasPersonalAccount
  include Kiqr::Teamable

  # => Model validations
  validates :email, presence: true, uniqueness: true
  validates :time_zone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) }
  validates :locale, inclusion: { in: Kiqr::Config.available_locales.map(&:to_s) }

  # Include any custom methods here
end
