require 'bundler/setup'
Bundler.setup

require 'bson'
require 'pry-byebug'
require 'grape'
require 'frodo'
require 'support/shared_context'
require 'json'
require 'ostruct'
require 'webmock/rspec'

RSpec.configure(&:raise_errors_for_deprecations!)
