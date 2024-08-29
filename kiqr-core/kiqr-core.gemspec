version = File.read(File.expand_path("../KIQR_VERSION", __dir__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "kiqr-core"
  s.version     = version
  s.summary     = "Kickstart your SaaS development with Kiqr"
  s.description = "KIQR is a Rails engine that provides a solid foundation for building SaaS applications."

  s.required_ruby_version     = ">= 3.1.0"
  s.required_rubygems_version = ">= 1.8.11"

  s.license = "MIT"

  s.author   = "Rasmus Kjellberg"
  s.email    = "kjellberg@hey.com"
  s.homepage = "https://kiqr.dev"

  s.files        = Dir["MIT-LICENSE", "README.md", "lib/**/*", "app/**/*", "config/**/*", "db/**/*"]
  s.require_path = "lib"

  s.metadata = {
    "bug_tracker_uri"   => "https://github.com/kiqr/kiqr/issues",
    "changelog_uri"     => "https://github.com/kiqr/kiqr/releases/tag/v#{version}",
    "documentation_uri" => "https://docs.kiqr.dev",
    "source_code_uri"   => "https://github.com/kiqr/kiqr/tree/v#{version}",
    "rubygems_mfa_required" => "true"
  }

  s.add_dependency "devise", "~> 4.9", ">= 4.9.3"
  s.add_dependency "devise-two-factor", ">= 5.0", "< 5.2"
  s.add_dependency "omniauth", "~> 2.1.1"
  s.add_dependency "omniauth-rails_csrf_protection", "~> 1.0.1"
  s.add_dependency "public_uid", "~> 2.2"

  # Commands
  s.add_dependency "awesome_print", "~> 1.9", ">= 1.9.2"

  # KIQR dependencies
  s.add_dependency "kiqr-frontend", version
end
