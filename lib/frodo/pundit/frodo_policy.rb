# frozen_string_literal: true

module Frodo
  module Pundit
    class FrodoPolicy
      def initialize(frodo_user, record)
        @frodo_user = frodo_user
        @record = record
        @privileges = frodo_user.privileges.freeze
      end

      private

      attr_reader :frodo_user, :record, :privileges

      def client_application_name
        @client_application_name ||= frodo_user.name
      end

      # rubocop:disable Naming/PredicateName
      def has_privilege?(privilege, scope = nil)
        return true if dredd?

        scoped_privilege = "#{scope}::#{privilege}".upcase

        raise Frodo::Errors::MissingPrivilegeError
          .new(
            privilege,
            scope
          ) unless privileges.include?(privilege.upcase.to_s) || (scope.present? && privileges.include?(scoped_privilege))
        true
      end
      # rubocop:enable Naming/PredicateName

      def salido_pos?
        client_application_name == 'SALIDO_POS'
      end

      def owner?
        return true if dredd?
        frodo_user.try(:id).present? && frodo_user.id == record.try(:resource_owner_id)
      end

      def dredd?
        ENV['DREDD'].to_i == 1
      end
    end
  end
end
