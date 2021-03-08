# frozen_string_literal: true

require_relative "lib/chilean/rutify/version"

Gem::Specification.new do |spec|
  spec.name          = "chilean-rutify"
  spec.version       = Chilean::Rutify::VERSION
  spec.authors       = ["Mihail Pozarski"]
  spec.email         = ["mihailpozarski@outlook.com"]

  spec.summary       = "Rails chilean rut validator formater"
  spec.description   = "A useful chilean rut validator and formater for Rails"
  spec.homepage      = "https://github.com/mihailpozarski/chilean-rutify"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
