module Kiqr::RendersSubmenu
  extend ActiveSupport::Concern

  included do
    helper_method :submenu_partial, :has_submenu?
  end

  module ClassMethods
    def renders_submenu(partial:, **options)
      before_action -> { set_submenu_partial(partial: partial) }, **options
    end
  end

  private

  def has_submenu?
    !@_submenu_partial.nil?
  end

  def submenu_partial
    @_submenu_partial
  end

  def set_submenu_partial(partial:)
    @_submenu_partial = partial
  end
end
