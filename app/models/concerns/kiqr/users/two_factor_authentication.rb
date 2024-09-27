# Provides functionality for managing two-factor authentication (2FA) for users.
module Kiqr
  module Users
    module TwoFactorAuthentication
      extend ActiveSupport::Concern

      included do
        # Using the "devise-two-factor" gem
        devise :two_factor_authenticatable
      end

      # Generates the OTP provisioning URI used by authentication apps to generate codes.
      # @return [String] the provisioning URI.
      def otp_uri
        issuer = Rails.configuration.application_name
        otp_provisioning_uri(email, issuer: issuer)
      end

      # Checks if two-factor authentication is enabled for the user.
      # @return [Boolean] whether two-factor authentication is enabled.
      def two_factor_enabled?
        otp_required_for_login?
      end

      # Resets the user's OTP secret and disables two-factor authentication.
      # @return [void]
      def reset_otp_secret!
        update!(
          otp_secret: generate_otp_secret,
          otp_required_for_login: false,
          consumed_timestep: nil,
          otp_backup_codes: nil
        )
      end

      protected

      # Generates a new OTP secret using the given length.
      # @param otp_secret_length [Integer] the length of the OTP secret.
      # @return [String] the newly generated OTP secret.
      def generate_otp_secret(otp_secret_length = Devise.otp_secret_length)
        ROTP::Base32.random_base32(otp_secret_length)
      end
    end
  end
end
