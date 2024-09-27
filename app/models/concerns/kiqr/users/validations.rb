# Defines validation rules for the User model.
module Kiqr
  module Users
    module Validations
      extend ActiveSupport::Concern

      included do
        # Validates the presence and uniqueness of email.
        validates :email, presence: true, uniqueness: true

        # Validates that the time zone is a valid option.
        validates :time_zone, inclusion: { in: -> { ActiveSupport::TimeZone.all.map(&:name) } }

        # Validates that the locale is a valid option.
        validates :locale, inclusion: { in: -> { I18n.available_locales.map(&:to_s) } }
      end
    end
  end
end
