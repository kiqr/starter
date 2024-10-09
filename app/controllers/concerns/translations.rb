module Translations
  extend ActiveSupport::Concern

  included do
    before_action :setup_locale_based_on_current_user
  end

  protected

  # Set the locale based on the current user's locale.
  # @return [void]
  def setup_locale_based_on_current_user
    I18n.locale = current_user&.locale&.to_sym || I18n.default_locale
  end
end
