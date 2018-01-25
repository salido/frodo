# frozen_string_literal: true

RSpec.shared_context 'frodo_user' do
  let(:client_application) do
    @client_application ||= begin
      OpenStruct.new(
        'id' => nil,
        'type' => 'client_applications',
        'privileges' => client_application_acl.dig('data', 'attributes', 'privileges'),
        'name' => client_application_acl.dig('data', 'attributes', 'client_application')
      )
    end
  end

  let(:user) do
    @user ||= begin
      return client_application if user_acl['included'].empty?
      user_object = user_acl['included'].select { |obj| obj['type'] == 'users' }.first
      OpenStruct.new(user_object['attributes']
        .merge(
          'id' => user_object['id'],
          'type' => 'users',
          'privileges' => user_acl.dig('data', 'attributes', 'privileges'),
          'name' => client_application.name
        )).freeze
    end
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
