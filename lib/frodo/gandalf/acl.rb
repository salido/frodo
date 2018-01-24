# frozen_string_literal: true

module Frodo
  module Gandalf
    class Acl
      def self.instance(token, resource = nil)
        new(token, resource)
      end

      def acl # rubocop:disable Metrics/MethodLength
        return if dredd?
        gandalf_acl if good_token?
      rescue Errno::ECONNREFUSED => e
        raise Frodo::Gandalf::Errors::BadUrlError.new(e.message)
      rescue JSON::ParserError => e
        raise Frodo::Gandalf::Errors::JsonError.new(e.message)
      rescue Frodo::Gandalf::Errors::TokenExpiredError => e
        raise e
      rescue StandardError => e
        raise Frodo::Gandalf::Errors::AclError.new(e.message)
      end

      private

      attr_reader :resource, :token

      def initialize(token, resource = nil)
        unless token.present?
          raise Frodo::Gandalf::Errors::MissingTokenError.new unless dredd?
        end
        @resource = resource
        @token = token.to_s
      end

      def good_token?
        raise StandardError.new(gandalf_acl['error']) if gandalf_acl['error']
        true
      end

      def gandalf_acl
        @gandalf_acl ||= begin
          response = HTTParty.get(gandalf_url, headers: { 'AUTHORIZATION' => token })
          JSON.parse(response.body)
        end
      end

      def gandalf_url
        query = "?resource=#{resource}" if resource
        ENV['GANDALF_ACL_URL'].to_s + query.to_s
      end

      def dredd?
        ENV['DREDD'].to_i == 1
      end
    end
  end
end
