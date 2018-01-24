# frozen_string_literal: true

module Frodo
  module Gandalf
    class Federate < Grape::Middleware::Base
      def before
        return unless endpoint_protected?
        Frodo::Gandalf::Acl.instance(current_token, resource_name)
      end

      private

      def context
        env['api.endpoint']
      end

      def current_token
        env['HTTP_AUTHORIZATION']
      end

      def endpoint_protected?
        context.options[:route_options][:auth].present?
      end

      def resource_name
        r = context.options.dig(:route_options, :auth, :resource)
        return r unless r == :all
        nil
      end
    end
  end
end
