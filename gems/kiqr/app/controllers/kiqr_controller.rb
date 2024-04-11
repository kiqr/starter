class KiqrController < ApplicationController
  private

  def kiqr_flash_message(type, message, **)
    flash[type] = I18n.t("kiqr.flash_messages.#{message}", **)
  end
end
