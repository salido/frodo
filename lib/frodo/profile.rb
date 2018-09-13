# frozen_string_literal: true

module Frodo
  class Profile
    def self.get(id:, token:, version: 'latest')
      gandalf_url = ENV['GANDALF_URL'].to_s + "/profiles/#{id}/#{version}"
      new(gandalf_url: gandalf_url, token: token)
    end

    def self.instance(location:, token:)
      gandalf_url = ENV['GANDALF_URL'].to_s + "/location/#{location.id}/profile"
      new(gandalf_url: gandalf_url, token: token)
    end

    def data
      @data ||= begin
        raise Frodo::Errors::ProfileError.new(gandalf_profile['error']) unless valid?
        gandalf_profile
      end
    end

    private

    attr_reader :gandalf_url, :token

    def initialize(gandalf_url:, token:)
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
      { Authorization: "Bearer #{token}" }
    end

    def valid?
      !(gandalf_profile.key? 'error')
    end
  end
end
