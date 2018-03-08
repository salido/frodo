# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

require 'bson'
require 'frodo'
require 'grape'
require 'json'
require 'ostruct'
require 'pry-byebug'
require 'pundit'
require 'support/shared_context'
require 'support/frodo_user'
require 'webmock/rspec'

RSpec.configure(&:raise_errors_for_deprecations!)
