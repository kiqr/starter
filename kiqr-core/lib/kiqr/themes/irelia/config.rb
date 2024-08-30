module Kiqr
  module Themes
    module Irelia
      class Config < Kiqr::Frontend::ThemeConfig
        # ==> View path
        # Specifies the directory path where the theme's view templates are located.
        # This allows customization of the theme's view rendering location.
        self.view_path = File.expand_path("../views", __FILE__)
      end
    end
  end
end
