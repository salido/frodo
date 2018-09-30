# frozen_string_literal: true

module Frodo
  class UserFinder
    def self.run(token:, user_id:)
      new(token: token, user_id: user_id).run
    end

    def run
      raise Errors::NotFoundError.new(error) if response.code == 404
      raise StandardError.new(error) unless response.code == 200
      user
    end

    private

    attr_reader :user_id, :token

    def initialize(token:, user_id:)
      raise Frodo::Errors::MissingTokenError.new unless token.present?
      raise ArgumentError.new unless user_id.present?
      @token = token.to_s
      @user_id = user_id
    end

    def response
      @response ||= HTTParty.get(url, headers: { 'AUTHORIZATION' => token })
    end

    def body
      JSON.parse(response.body)
    end

    # rubocop:disable Metrics/AbcSize
    def user
      Frodo::User::FORMAT.new(
        body['data']['id'],
        'users',
        "#{body['data']['attributes']['first_name']} #{body['data']['attributes']['last_name']}",
        body['data']['attributes']['platform_id'],
        'privileges' => [],
        'client_application' => nil
      )
    end
    # rubocop:enable Metrics/AbcSize

    def error
      body['error']
    end

    def url
      "#{ENV['GANDALF_URL']}/users/#{user_id}"
    end
  end
end
