# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'teacher/version'

Gem::Specification.new do |spec|
  spec.name          = "teacher"
  spec.version       = Teacher::VERSION
  spec.authors       = ["mrodrigues"]
  spec.email         = ["mrodrigues.uff@gmail.com"]
  spec.summary       = %q{Flexible language for defining grades calculations.}
  spec.homepage      = "https://github.com/mrodrigues/teacher"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "treetop", "1.5.3"
end
