module Kiqr
  # TwoFactorAuthenticatable module
  # This module is used to add two factor authentication to a model..
  # It is included in the User model.
  module TwoFactorAuthenticatable
    extend ActiveSupport::Concern

    included do
      devise :two_factor_authenticatable # From the devise-two-factor gem
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
  end
end
