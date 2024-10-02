# frozen_string_literal: true

require_relative "lib/form_wizard/version"

Gem::Specification.new do |spec|
  spec.name = "form_wizard"
  spec.version = FormWizard::VERSION
  spec.authors = [ "Rasmus Kjellberg" ]
  spec.email = [ "2277443+kjellberg@users.noreply.github.com" ]

  spec.summary = "Create multi-step forms with a form object."
  spec.description = "Multi-step form objects using a simple DSL with custom validations per step."
  spec.homepage = "https://github.com/kiqr/form_wizard"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kiqr/form_wizard"
  spec.metadata["changelog_uri"] = "https://github.com/kiqr/form_wizard"

  spec.files = Dir["{lib}/**/*", "LICENSE.md", "README.md"]
  spec.require_paths = [ "lib" ]
end
