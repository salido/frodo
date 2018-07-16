# frozen_string_literal: true

module Frodo
  module FrodoHelpers
    def acl
      @acl ||= Frodo::Acl.instance(token).acl
    end

    def current_user
      @current_user ||= Frodo::User
                        .instance(acl)
                        .frodo_user # NOTE: "User" can be a Client Application or a User
    end

    def current_application_name
      @current_application_name ||= begin
        if current_user.type == 'users'
          current_user.client_application.name
        else
          current_user.name
        end
      end
    end

    private

    def token
      headers['Authorization']
    end
  end
end
