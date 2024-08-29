# Require necessary dependencies
require "importmap-rails"

# Require local files for the Irelia theme
require "kiqr/themes/irelia/version"
require "kiqr/themes/irelia/engine"
require "kiqr/themes/irelia/config"

module Kiqr
  module Themes
    module Irelia
      # Class method to access the Irelia theme configuration
      # This method uses memoization to store the config instance
      def self.config
        # If @config is nil, initialize it with Kiqr::Themes::Irelia::Config
        # Otherwise, return the existing @config
        @config ||= Kiqr::Themes::Irelia::Config
      end
    end
  end
end
