# frozen_string_literal: true

module Frodo
  module Gandalf
    module Errors
      class JsonError < StandardError
        def initialize(msg = 'Json Parse error on ACL')
          super(msg)
        end
      end
    end
  end
end
