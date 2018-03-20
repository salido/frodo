# frozen_string_literal: true

module Frodo
  class UserFinder
    def self.run(token:, user_id:)
      new(token: token, user_id: user_id).run
    end

    def run
      raise Errors::NotFoundError.new(error) if response.code == 404
      raise StandardError.new(error) unless response.code == 200
      OpenStruct.new(user)
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

    def user
      body['data']
    end

    def error
      body['error']
    end

    def url
      "#{ENV['GANDALF_URL']}/users/#{user_id}"
    end
  end
end
