module Kiqr
  module Translations
    module Controllers
      module Helpers
        extend ActiveSupport::Concern

        included do
          before_action :setup_locale_based_on_current_user
        end

        protected

        def setup_locale_based_on_current_user
          I18n.locale = current_user&.locale&.to_sym || I18n.default_locale
        end
      end
    end
  end
end
