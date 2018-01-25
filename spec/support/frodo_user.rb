# frozen_string_literal: true

RSpec.shared_context 'frodo_user' do
  let(:client_application) do
    @client_application ||= Frodo::User.new(client_application_acl).frodo_user
  end

  let(:user) do
    @user ||= Frodo::User.new(user_acl).frodo_user
  end

  let(:resource_owner_id) { '1234567890uuid' }
  let(:client_app) { 'TEST_POLICY_APP' }
  let(:gandalf_privileges) { [] }
  let(:groups) { [] }
  let(:user_attributes) do
    {
      'disabled_by_salido' => false,
      'first_name' => 'Current',
      'last_name' => 'User',
      'time_zone' => 'EST',
      'legally_agreed_at' => '2016-11-28 18:58:32 UTC',
      'legally_agreed_ip_address' => '192.168.0.1',
      'email' => 'gandalf@example.com',
      'platform_id' => '5a1db1d835aca16381e65a76'
    }
  end

  let(:client_application_acl) do
    {
      'jsonapi' => { 'version' => '1.0' },
      'data' => {
        'id' => 0,
        'type' => 'acls',
        'attributes' => {
          'client_application' => client_app,
          'privileges' => gandalf_privileges
        },
        'relationships' => {
          'groups' => { 'data' => groups }
        }
      },
      'included' => []
    }
  end

  let(:user_acl) do
    {
      'jsonapi' => { 'version' => '1.0' },
      'data' => {
        'id' => 0,
        'type' => 'acls',
        'attributes' => {
          'client_application' => client_app,
          'privileges' => gandalf_privileges
        },
        'relationships' => {
          'user' => {
            'data' => {
              'id' => resource_owner_id,
              'type' => 'users'
            }
          },
          'groups' => { 'data' => groups }
        }
      },
      'included' => [
        {
          'id' => resource_owner_id,
          'type' => 'users',
          'attributes' => user_attributes
        }
      ]
    }
  end
end
