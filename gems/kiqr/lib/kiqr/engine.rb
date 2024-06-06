require "kiqr/rails/routes"

module Kiqr
  class Engine < ::Rails::Engine
    initializer "kiqr.action_mailer" do |app|
      config.action_mailer.default_url_options = Kiqr.default_url_options
    end
  end
end
