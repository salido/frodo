# frozen_string_literal: true

module Frodo
  module Errors
    class TokenExpiredError < StandardError
      def initialize(msg = 'Missing Authorization Token')
        super(msg)
      end
    end
  end
end
