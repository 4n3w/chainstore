# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chainstore/version'

Gem::Specification.new do |spec|
  spec.name          = 'chainstore'
  spec.version       = Chainstore::VERSION
  spec.authors       = ['Andrew Wood']
  spec.email         = ['andrew.d.wood@gmail.com']
  spec.summary       = %q{Store key/value pairs in a chain of k/v storage services.}
  spec.description   = %q{Store key/value pairs in a chain of k/v storage services organized in a chain of responsibility pattern.}
  spec.homepage      = 'http://github.com/4n3w/chainstore'
  spec.license       = 'MIT'
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w{lib/*}
  spec.add_dependency 'redis'
  spec.add_dependency 'aws-s3'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
