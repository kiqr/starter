require_relative "lib/kiqr/version"

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "kiqr"
  s.version     = Kiqr::VERSION
  s.summary     = "Kickstart your SaaS development with Kiqr"
  s.description = "KIQR is a Rails engine that provides a solid foundation for building SaaS applications."

  s.required_ruby_version     = ">= 3.1.0"
  s.required_rubygems_version = ">= 1.8.11"

  s.license = "MIT"

  s.author   = "Rasmus Kjellberg"
  s.email    = "kjellberg@hey.com"
  s.homepage = "https://kiqr.dev"

  s.files        = Dir["MIT-LICENSE", "README.md", "lib/**/*", "app/**/*", "config/**/*", "db/**/*", "exe/**/*"]
  s.require_path = "lib"

  s.bindir      = "exe"
  s.executables = [ "kiqr" ]

  s.metadata = {
    "bug_tracker_uri"   => "https://github.com/kiqr/kiqr/issues",
    "changelog_uri"     => "https://github.com/kiqr/kiqr/releases/tag/v#{Kiqr::VERSION}",
    "documentation_uri" => "https://docs.kiqr.dev",
    "source_code_uri"   => "https://github.com/kiqr/kiqr/tree/v#{Kiqr::VERSION}",
    "rubygems_mfa_required" => "true"
  }

  # Rails dependencies
  s.add_dependency "rails", ">= 7.2.1"
  s.add_dependency "importmap-rails", "~> 2.0", ">= 2.0.1"
  s.add_dependency "turbo-rails", "~> 2.0", ">= 2.0.6"
  s.add_dependency "stimulus-rails", "~> 1.3", ">= 1.3.4"

  # Core dependencies
  s.add_dependency "devise", "~> 4.9", ">= 4.9.3"
  s.add_dependency "devise-two-factor", ">= 5.0", "< 5.2"
  s.add_dependency "omniauth", "~> 2.1.1"
  s.add_dependency "omniauth-rails_csrf_protection", "~> 1.0.1"
  s.add_dependency "public_uid", "~> 2.2"

  # Frontend dependencies
  s.add_dependency "meta-tags", "~> 2.21"
  s.add_dependency "loaf", "~> 0.10.0"
  s.add_dependency "rqrcode", "~> 2.0"

  # CLI and app generator dependencies
  s.add_dependency "awesome_print", "~> 1.9", ">= 1.9.2"
  s.add_dependency "thor", "~> 1.3", ">= 1.3.1"
end
