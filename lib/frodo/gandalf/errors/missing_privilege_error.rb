# frozen_string_literal: true

module Frodo
  module Gandalf
    module Errors
      class MissingPrivilegeError < StandardError
        def initialize(privilege, scope = nil, msg = 'Missing required privilege')
          message = scope.present? ? "#{msg} #{privilege} for #{scope}" : "#{msg} #{privilege}"
          super(message)
        end
      end
    end
  end
end
