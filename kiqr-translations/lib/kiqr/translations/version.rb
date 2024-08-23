require_relative "gem_version"

module Kiqr
  module Translations
    def self.version
      gem_version
    end
  end
end
