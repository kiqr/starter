require_relative "lib/kiqr/translations/version"

Gem::Specification.new do |spec|
  spec.name = "kiqr-translations"
  spec.version = Kiqr::Translations::VERSION
  spec.authors = [ "Rasmus Kjellberg" ]
  spec.email = [ "2277443+kjellberg@users.noreply.github.com" ]
  spec.homepage = "https://kiqr.dev"
  spec.summary = "Translations for KIQR framework"
  spec.description = "Includes I18n translations for KIQR framework."
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kiqr/kiqr-translations"
  spec.metadata["changelog_uri"] = "https://github.com/kiqr/kiqr-translations"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end
end
