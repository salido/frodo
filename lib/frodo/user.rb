# frozen_string_literal: true

module Frodo
  class User
    FORMAT = Struct.new(:id, :type, :name, :platform_id, :privileges, :client_application)

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
      # "attributes": {
      #           "name": "devo-khan",
      #           "uid": "71e427fa277025f924503b033ae26e7d5a3fb1ba8e722eb55cd3de49123513e3",
      #           "redirect_uri": "https://localhost:8080",
      #           "created_at": "2018-09-26T20:25:19Z",
      #           "updated_at": "2018-09-26T20:25:19Z"
      @client_application ||= FORMAT.new(
        client_app_object['id'],
        'client_applications',
        client_app_object['attributes']['name'],
        nil,
        privileges,
        client_app_object
      )
    end

    def privileges
      acl.dig('data', 'attributes', 'privileges').map(&:upcase)
    end

    def user
      # "attributes": {
      #   "platform_id": null,
      #   "first_name": "devo",
      #   "last_name": "regmi",
      #   "password": null,
      #   "email": "devo.regmi@salido.com"
      FORMAT.new(
        user_object['id'],
        'users',
        "#{user_object['attributes']['first_name']} #{user_object['attributes']['last_name']}",
        user_object['attributes']['platform_id'],
        privileges,
        client_application
      )
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
