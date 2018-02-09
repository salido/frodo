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

    def current_application
      @current_application ||= Frodo::User.instance(acl).client_application
    end

    private

    def token
      headers['Authorization']
    end
  end
end
