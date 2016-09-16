# coding: utf-8
require_relative "lib/en_masse/version"

Gem::Specification.new do |spec|
  spec.name          = "en_masse"
  spec.version       = EnMasse::VERSION
  spec.authors       = ["Artem Baguinski"]
  spec.email         = ["abaguinski@depraktijkindex.nl"]

  spec.summary       = %q{Operations on arrays of active records.}
  spec.homepage      = "https://github.com/praktijkindex/en_masse"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = "~> 2.1"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "yard", "~> 0.8.7"
  spec.add_development_dependency "redcarpet", "~> 3.2"

  spec.add_runtime_dependency "activesupport", ">= 4.2"
  spec.add_runtime_dependency "activerecord", ">= 4.2"
end
