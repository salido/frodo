# frozen_string_literal: true

module Frodo
  class Acl
    def self.instance(token, resource = nil)
      new(token, resource)
    end

    def acl # rubocop:disable Metrics/MethodLength
      gandalf_acl if good_token?
    rescue Errno::ECONNREFUSED => e
      raise Frodo::Errors::BadUrlError.new(e.message)
    rescue JSON::ParserError => e
      raise Frodo::Errors::JsonError.new(e.message)
    rescue Frodo::Errors::TokenExpiredError => e
      raise e
    rescue StandardError => e
      raise Frodo::Errors::AclError.new(e.message)
    end

    private

    attr_reader :resource, :token

    def initialize(token, resource = nil)
      raise Frodo::Errors::MissingTokenError.new unless token.present?
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
  end
end
