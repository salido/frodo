# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require File.expand_path('../lib/frodo/gandalf/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'frodo'
  spec.version       = Frodo::Gandalf::VERSION
  spec.authors       = ['Ari Perez']
  spec.email         = ['aris.a.perez@gmail.com']

  spec.summary       = 'Gandalf... gemified'
  spec.description   = ''
  spec.license       = 'MIT'

  spec.add_runtime_dependency 'grape'
  spec.add_runtime_dependency 'httparty'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'bson'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.48'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'webmock'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec}/*`.split("\n")
  spec.require_paths = ['lib']
end
