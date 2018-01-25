# frozen_string_literal: true

module Frodo
  class User
    def self.instance(acl)
      @instances ||= {}
      @instances[acl] ||= new(acl)
    end

    def frodo_user
      @frodo_user ||= begin
        return client_application if acl['included'].empty?
        user_object = acl['included'].select { |obj| obj['type'] == 'users' }.first
        user(user_object)
      end
    end

    private

    attr_reader :acl

    def client_application
      @client_application ||= begin
        OpenStruct.new(
          'id' => nil,
          'type' => 'client_applications',
          'privileges' => privileges,
          'name' => acl.dig('data', 'attributes', 'client_application')
        )
      end
    end

    def privileges
      acl.dig('data', 'attributes', 'privileges').map(&:upcase)
    end

    def user(user_object)
      OpenStruct.new(user_object['attributes']
        .merge(
          'id' => user_object['id'],
          'type' => 'users',
          'privileges' => privileges,
          'name' => client_application.name
        )).freeze
    end

    def initialize(acl)
      raise Frodo::Errors::MissingAclError.new unless acl.present?

      @acl = acl
    end
  end
end
