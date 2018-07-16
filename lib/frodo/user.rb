# frozen_string_literal: true

module Frodo
  class User
    def self.instance(acl)
      @instances ||= {}
      @instances[acl] ||= new(acl)
    end

    def frodo_user
      @frodo_user ||= begin
        return client_application if user_object.nil?
        user
      end
    end

    private

    attr_reader :acl

    def client_app_object
      @client_app_object ||= acl['included'].select { |obj| obj['type'] == 'client_applications' }.first
    end

    def client_application
      @client_application ||= begin
        OpenStruct.new(client_app_object['attributes']
          .merge(
            'id' => client_app_object['id'],
            'type' => 'client_applications',
            'privileges' => privileges
          )).freeze
      end
    end

    def privileges
      acl.dig('data', 'attributes', 'privileges').map(&:upcase)
    end

    def user
      OpenStruct.new(user_object['attributes']
        .merge(
          'id' => user_object['id'],
          'type' => 'users',
          'privileges' => privileges,
          'client_application' => client_application
        )).freeze
    end

    def user_object
      @user_object ||= acl['included'].select { |obj| obj['type'] == 'users' }.first
    end

    def initialize(acl)
      raise Frodo::Errors::MissingAclError.new unless acl.present?

      @acl = acl
    end
  end
end
