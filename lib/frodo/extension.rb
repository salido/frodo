# frozen_string_literal: true

module Frodo
  module Extension
    def protect(resource = :all)
      description = if respond_to?(:route_setting) # >= grape-0.10.0
                      route_setting(:description) || route_setting(:description, {})
                    else
                      @last_description ||= {}
                    end
      description[:auth] = { resource: resource.to_sym }
    end

    Grape::API.extend self
  end
end
