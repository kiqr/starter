require "meta-tags"
require "loaf"
require "rqrcode"

require "kiqr/themes/irelia"

module Kiqr
  module Config
    config_accessor :theme, default: "irelia"
  end

  module Frontend
    autoload :Helpers, "kiqr/frontend/helpers"
    autoload :FormHelpers, "kiqr/frontend/form_helpers"
    autoload :ViewHelpers, "kiqr/frontend/view_helpers"

    module Controllers
      autoload :RendersSubmenu, "kiqr/frontend/controllers/renders_submenu"
    end
  end
end
