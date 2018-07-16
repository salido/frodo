# frozen_string_literal: true

module Frodo
  module Pundit
    class FrodoPolicy
      def initialize(frodo_user, record)
        @frodo_user = frodo_user
        @record = record
        @privileges = frodo_user.privileges.map { |p| clean_privilege(p) }.freeze
      end

      private

      attr_reader :frodo_user, :record, :privileges

      alias_method :user, :frodo_user

      def clean_privilege(priv)
        priv.to_s.delete('-').upcase
      end

      def client_application_name
        @client_application_name ||= begin
          if frodo_user.type == 'users'
            frodo_user.client_application.name
          else
            frodo_user.name
          end
        end
      end

      # rubocop:disable Naming/PredicateName
      def has_privilege?(privilege, scope = nil)
        candidates = ["#{scope}::#{privilege}", privilege].map { |p| clean_privilege(p) }
        unless (privileges & candidates).count.positive?
          raise Frodo::Errors::MissingPrivilegeError
            .new(privilege, scope)
        end

        true
      end
      # rubocop:enable Naming/PredicateName

      def salido_pos?
        client_application_name == 'SALIDO_POS'
      end

      def salido_bridge?
        client_application_name == 'SALIDO_BRIDGE'
      end

      def owner?
        frodo_user.try(:id).present? && frodo_user.id == record.try(:resource_owner_id)
      end
    end
  end
end
