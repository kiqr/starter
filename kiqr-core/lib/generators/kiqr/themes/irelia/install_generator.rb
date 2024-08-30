require "pathname"
require "rails/generators"

module Kiqr
  module Themes
    module Irelia
      class InstallGenerator < Rails::Generators::Base
        source_paths << File.expand_path("templates", __dir__)

        def write_to_importmap
          inject_into_file "config/importmap.rb", "\npin \"irelia\", to: \"irelia.js\"\n"
        end

        def write_to_stimulus_controller
          inject_into_file "app/javascript/controllers/index.js", "\n\nimport { registerIreliaControllers } from \"irelia\";\nregisterIreliaControllers(application);\n"
        end
      end
    end
  end
end
