# frozen_string_literal: true

module Frodo
  class OnlineOrdererFinder
    def self.run(token:, org_id:, online_orderer:)
      new(token: token, org_id: org_id, online_orderer: online_orderer).run
    end

    def run
      raise Errors::NotFoundError.new(error) if response.code == 404
      raise StandardError.new(error) unless response.code == 200
      OpenStruct.new(user)
    end

    private

    attr_reader :org_id, :token, :online_orderer

    def initialize(token:, org_id:, online_orderer:)
      raise Frodo::Errors::MissingTokenError.new unless token.present?
      raise ArgumentError.new unless org_id.present?
      @token = token.to_s
      @org_id = org_id
      @online_orderer = online_orderer
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
      "#{ENV['GANDALF_URL']}/organizations/#{org_id}/#{online_orderer}"
    end
  end
end
