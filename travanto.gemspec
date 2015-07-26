# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "travanto"
  spec.version       = Travanto::VERSION
  spec.authors       = ["Raphael Randschau"]
  spec.email         = ["rrandschau@weluse.de"]
  spec.description   = %q{travanto.de api client}
  spec.summary       = %q{travanto.de api client}
  spec.homepage      = "http://weluse.de"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest", "~> 4.7.3"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "typhoeus", ">= 0.6.3"
end
