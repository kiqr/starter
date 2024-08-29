module Kiqr
  module Config
    config_accessor :theme, default: "irelia"
  end

  module Frontend
    autoload :Helpers, "kiqr/frontend/helpers"
    autoload :FormHelpers, "kiqr/frontend/form_helpers"
    autoload :ViewHelpers, "kiqr/frontend/view_helpers"
    autoload :ThemeConfig, "kiqr/frontend/theme_config"

    module Controllers
      autoload :RendersSubmenu, "kiqr/frontend/controllers/renders_submenu"
    end
  end
end
