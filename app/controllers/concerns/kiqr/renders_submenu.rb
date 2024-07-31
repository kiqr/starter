module Kiqr::RendersSubmenu
  extend ActiveSupport::Concern

  included do
    helper_method :submenu_partial, :has_submenu?
  end

  def submenu_partial
    self.class.submenu_partial
  end

  def has_submenu?
    !submenu_partial.nil?
  end

  class_methods do
    def submenu_partial
      if instance_variable_defined?(:@_submenu_partial)
        @_submenu_partial
      elsif superclass.respond_to?(:submenu_partial)
        superclass.submenu_partial
      end
    end

    def renders_submenu(partial:)
      @_submenu_partial = partial
    end
  end
end
