module Kiqr
  module TwoFactorAuthentication
    extend ActiveSupport::Concern

    included do
      helper_method :two_factor_enabled?
    end

    private

    def two_factor_enabled?
      current_user.otp_required_for_login?
    end
  end
end
