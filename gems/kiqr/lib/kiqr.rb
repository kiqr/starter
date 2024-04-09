require "kiqr/version"
require "kiqr/engine"

module Kiqr
  autoload :Config, "kiqr/config"

  def config
    @config ||= Kiqr::Config
  end
end
