# frozen_string_literal: true

module Frodo
  class Profile
    def self.get(id:, version: 'latest')
      gandalf_url = ENV['GANDALF_URL'].to_s + "/profiles/#{id}/#{version}"
      new(gandalf_url: gandalf_url)
    end

    def self.instance(location:)
      gandalf_url = ENV['GANDALF_URL'].to_s + "/location/#{location.id}/profile"
      new(gandalf_url: gandalf_url)
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
      data.dig('data', 'attributes', 'data', 'configs')
    end

    def data
      @data ||= begin
        raise Frodo::Errors::ProfileError.new(gandalf_profile['error']) unless valid?
        gandalf_profile
      end
    end

    private

    def initialize(gandalf_url:)
      @gandalf_url = gandalf_url
    end

    attr_reader :gandalf_url

    def profile_response
      @profile_response ||= HTTParty.get(gandalf_url)
    rescue Errno::ECONNREFUSED => e
      raise Frodo::Errors::BadUrlError.new(e.message)
    end

    def gandalf_profile
      JSON.parse(profile_response.body)
    rescue JSON::ParserError => e
      raise Frodo::Errors::JsonError.new(e.message)
    end

    def valid?
      !(gandalf_profile.key? 'error')
    end
  end
end
