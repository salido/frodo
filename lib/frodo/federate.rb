# frozen_string_literal: true

module Frodo
  class Federate < Grape::Middleware::Base
    def before
      return unless endpoint_protected?
      Frodo::Acl.instance(current_token, resource_name)
    end

    private

    def context
      env['api.endpoint']
    end

    def current_token
      env['HTTP_AUTHORIZATION']
    end

    def endpoint_protected?
      context.options.dig(:route_options, :auth).present?
    end

    def resource_name
      r = context.options.dig(:route_options, :auth, :resource)
      return r unless r == :all
      nil
    end
  end
end
