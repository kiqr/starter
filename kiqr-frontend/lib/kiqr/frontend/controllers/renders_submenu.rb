module Kiqr
  module Frontend
    module Controllers
      module RendersSubmenu
        extend ActiveSupport::Concern

        included do
          helper_method :submenu_partial, :has_submenu?
        end

        def submenu_partial
          @_submenu_partial
        end

        def has_submenu?
          !@_submenu_partial.nil?
        end

        module ClassMethods
          def renders_submenu(partial:, **options)
            before_action -> { set_submenu_partial(partial: partial) }, **options
          end
        end

        protected

        def set_submenu_partial(partial:)
          @_submenu_partial = partial
        end
      end
    end
  end
end
