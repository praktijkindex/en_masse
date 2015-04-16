# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "en_masse/version"

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

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "activerecord", "~> 4.0"
end
