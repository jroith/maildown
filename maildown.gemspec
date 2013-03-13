# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'maildown/version'

Gem::Specification.new do |spec|
  spec.name          = "maildown"
  spec.version       = Maildown::VERSION
  spec.authors       = ["Ludwig Schubert"]
  spec.email         = ["maildown@ludwigschubert.de"]
  spec.description   = "Maildown handles converting HTML to a subset of markdown in certain opinioned ways that are commonly used in plaintext emails."
  spec.summary       = "Maildown handles converting HTML to a subset of markdown in certain opinioned ways that are commonly used in plaintext emails."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'nokogiri'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry-debugger"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec"

end
