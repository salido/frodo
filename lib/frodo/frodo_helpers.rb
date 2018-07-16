# frozen_string_literal: true

module Frodo
  module FrodoHelpers
    def acl
      @acl ||= Frodo::Acl.instance(token).acl
    end

    def current_user
      @frodo_user ||= Frodo::User
                      .instance(acl)
                      .frodo_user # NOTE: "User" can be a Client Application or a User
    end

    def current_application_name
      @current_application_name ||= begin
        if frodo_user.type == 'users'
          frodo_user.client_application.name
        else
          frodo_user.name
        end
      end
    end

    private

    def token
      headers['Authorization']
    end
  end
end
