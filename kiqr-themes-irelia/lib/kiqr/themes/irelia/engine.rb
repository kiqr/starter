module Kiqr
  module Themes
    module Irelia
      class Engine < ::Rails::Engine
        initializer "kiqr-themes-irelia.importmap", before: "importmap" do |app|
          app.config.importmap.paths << Kiqr::Themes::Irelia::Engine.root.join("config/importmap.rb")
        end
      end
    end
  end
end
