require "meta-tags"
require "loaf"
require "rqrcode"

require "kiqr/themes/irelia"

require "kiqr/frontend/engine"
require "kiqr/frontend/version"

module Kiqr
  module Config
    config_accessor :theme, default: "irelia"
  end

  module Frontend
    autoload :FormHelpers, "kiqr/frontend/form_helpers"
    autoload :ViewHelpers, "kiqr/frontend/view_helpers"

    module Controllers
      autoload :Helpers, "kiqr/frontend/controllers/helpers"
      autoload :RendersSubmenu, "kiqr/frontend/controllers/renders_submenu"
    end
  end
end
