version = File.read(File.expand_path("../KIQR_VERSION", __dir__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "kiqr-cli"
  s.version     = version
  s.summary     = "Command line tool for the KIQR framework."
  s.description = "Generate extensions, update configs etc."

  s.required_ruby_version     = ">= 3.1.0"
  s.required_rubygems_version = ">= 1.8.11"

  s.license = "MIT"

  s.author   = "Rasmus Kjellberg"
  s.email    = "kjellberg@hey.com"
  s.homepage = "https://kiqr.dev"

  s.files        = Dir["MIT-LICENSE", "lib/**/*", "config/**/*"]
  s.require_path = "lib"

  s.bindir      = "exe"
  s.executables = [ "kiqr" ]

  s.metadata = {
    "bug_tracker_uri"   => "https://github.com/kiqr/kiqr/issues",
    "changelog_uri"     => "https://github.com/kiqr/kiqr/releases/tag/v#{version}",
    "documentation_uri" => "https://docs.kiqr.dev",
    "source_code_uri"   => "https://github.com/kiqr/kiqr/tree/v#{version}",
    "rubygems_mfa_required" => "true"
  }

  s.add_dependency "awesome_print", "~> 1.9", ">= 1.9.2"
  s.add_dependency "thor", "~> 1.3", ">= 1.3.1"
end
