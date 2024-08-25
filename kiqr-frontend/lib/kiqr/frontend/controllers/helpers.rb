module Kiqr
  module Frontend
    module Controllers
      module Helpers
        extend ActiveSupport::Concern
        include Kiqr::Frontend::Controllers::RendersSubmenu

        included do
          before_action :setup_view_path_for_themes
        end

        protected

        def setup_view_path_for_themes
          theme_name = Kiqr.config.theme.to_s.downcase
          theme_engine = "Kiqr::Themes::#{theme_name.camelize}::Engine".constantize

          append_view_path theme_engine.root.join("views")
        end
      end
    end
  end
end
