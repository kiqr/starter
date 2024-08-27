module Kiqr
  module Cli
    def self.version
      Gem.loaded_specs["kiqr-cli"].version
    end
  end
end
