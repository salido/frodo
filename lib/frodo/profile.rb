# frozen_string_literal: true

module Frodo
  class Profile
    def self.get(id:, version: 'latest')
      gandalf_url = ENV['GANDALF_URL'].to_s + "/profiles/#{id}?version=#{version}"
      new(gandalf_url: gandalf_url)
    end

    def self.instance(location:, token: nil)
      gandalf_url = ENV['GANDALF_URL'].to_s + "/location/#{location.id}/profile"
      new(gandalf_url: gandalf_url, token: token)
    end

    def id
      data.dig('data', 'id')
    end

    def version
      data.dig('data', 'attributes', 'version')
    end

    def configs
      data.dig('data', 'attributes', 'data', 'configs')
    end

    def client_applications
      data.dig('data', 'attributes', 'data', 'client_applications')
    end

    def data
      @data ||= begin
        raise Frodo::Errors::ProfileError.new(gandalf_profile['error']) unless valid?
        gandalf_profile
      end
    end

    private

    attr_reader :gandalf_url, :token

    def initialize(gandalf_url:, token: nil)
      @gandalf_url = gandalf_url
      @token = token
    end

    def profile_response
      @profile_response ||= HTTParty.get(gandalf_url, headers: headers)
    rescue Errno::ECONNREFUSED => e
      raise Frodo::Errors::BadUrlError.new(e.message)
    end

    def gandalf_profile
      JSON.parse(profile_response.body)
    rescue JSON::ParserError => e
      raise Frodo::Errors::JsonError.new(e.message)
    end

    def headers
      { Authorization: "Bearer #{token}" } if token.present?
    end

    def valid?
      !(gandalf_profile.key? 'error')
    end
  end
end
