require_relative "gem_version"

module Kiqr
  module Frontend
    def self.version
      gem_version
    end
  end
end
