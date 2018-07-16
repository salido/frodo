# frozen_string_literal: true

RSpec.shared_context 'frodo_user' do
  let(:client_application) do
    @client_application ||= Frodo::User.new(client_application_acl).frodo_user
  end

  let(:user) do
    @user ||= Frodo::User.new(user_acl).frodo_user
  end

  let(:resource_owner_id) { '1234567890uuid' }
  let(:client_application_id) { '0987654321uuid' }
  let(:gandalf_privileges) { [] }
  let(:groups) { [] }
  let(:client_application_attributes) do
    {
      'name' => 'TEST_POLICY_APP',
      'redirect_uri' => 'https://www.test_policy_app.com'
    }
  end
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
          'privileges' => gandalf_privileges
        },
        'relationships' => {
          'client_application' => {
            'data' => {
              'id' => client_application_id,
              'type' => 'clientapplications'
            }
          },
          'groups' => { 'data' => groups }
        }
      },
      'included' => [
        {
          'id' => client_application_id,
          'type' => 'client_applications',
          'attributes' => client_application_attributes
        }
      ]
    }
  end

  let(:user_acl) do
    {
      'jsonapi' => { 'version' => '1.0' },
      'data' => {
        'id' => 0,
        'type' => 'acls',
        'attributes' => {
          'privileges' => gandalf_privileges
        },
        'relationships' => {
          'client_application' => {
            'data' => {
              'id' => client_application_id,
              'type' => 'clientapplications'
            }
          },
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
          'id' => client_application_id,
          'type' => 'client_applications',
          'attributes' => client_application_attributes
        },
        {
          'id' => resource_owner_id,
          'type' => 'users',
          'attributes' => user_attributes
        }
      ]
    }
  end
end
