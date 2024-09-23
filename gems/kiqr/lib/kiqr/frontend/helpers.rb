module Kiqr
  module Frontend
    module Helpers
      extend ActiveSupport::Concern
      include Kiqr::Frontend::Controllers::RendersSubmenu

      included do
        before_action :setup_view_path_for_themes
      end

      protected

      def setup_view_path_for_themes
        theme_name = Kiqr.config.theme.to_s.camelize
        theme_class = "Kiqr::Themes::#{theme_name}".constantize
        append_view_path theme_class.config.view_path
      end
    end
  end
end
