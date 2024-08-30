module Kiqr
  module Frontend
    class ThemeConfig
      include ActiveSupport::Configurable

      # ==> View path
      # Specifies the directory path where the theme's view templates are located.
      # This allows customization of the theme's view rendering location.
      config_accessor :view_path
    end
  end
end
