# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'encx/version'

Gem::Specification.new do |spec|
  spec.name          = "encx"
  spec.version       = Encx::VERSION
  spec.licenses      = ['MIT']
  spec.authors       = ["yasuo kominami"]
  spec.email         = ["ykominami@gmail.com"]

  spec.summary       = %q{Encoding utility.}
  spec.description   = %q{Encoding utility.}
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 1.9'

  if spec.respond_to?(:metadata)
#    spec.metadata['allowed_push_host'] = "http://mygemserver.com"
  end

  spec.add_development_dependency "bundler", "~> 2.2.10"
  spec.add_development_dependency "rake", "~> 12.3.3"
  spec.add_development_dependency "rspec"
end
