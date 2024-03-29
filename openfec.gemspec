# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'openfec/version'

Gem::Specification.new do |spec|
  spec.name          = "openfec"
  spec.version       = OpenFec::VERSION
  spec.authors       = ["chriscondon"]
  spec.email         = ["chris.m.condon@gmail.com"]

  spec.summary       = %q{short summary, because Rubygems requires one.}
  spec.description   = %q{longer description or delete this line.}
  spec.homepage      = "http://www.github.com"
  spec.license       = "MIT"

  spec.files         = Dir.glob("{lib,spec}/**/*")
  #spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
