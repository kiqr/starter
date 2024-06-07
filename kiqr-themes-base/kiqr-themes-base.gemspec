require_relative "lib/kiqr/themes/base/version"

Gem::Specification.new do |spec|
  spec.name = "kiqr-themes-base"
  spec.version = Kiqr::Themes::Base::VERSION
  spec.authors = [ "Rasmus Kjellberg" ]
  spec.email = [ "2277443+kjellberg@users.noreply.github.com" ]
  spec.homepage = "https://kiqr.dev"
  spec.summary = "Base theme files for KIQR"
  spec.description = "Views and assets for KIQR themes."
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kiqr/kiqr-themes-base"
  spec.metadata["changelog_uri"] = "https://github.com/kiqr/kiqr-themes-base"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end
end
