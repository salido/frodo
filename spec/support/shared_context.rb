# frozen_string_literal: true

RSpec.shared_context 'shared context' do
  let(:token) { 'Bearer testToken123' }

  let(:gandalf_header) do
    { AUTHORIZATION: token }
  end

  let(:gandalf_employee) { double('employee', id: ::BSON::ObjectId.new) }

  let(:gandalf_privileges) { %w[GONDOR ISENGUARD ITHILLIEN LOTHLORIEN MORDOR] }

  let(:gandalf_user_id) { SecureRandom.uuid }

  let(:groups) { [] }
  let(:client_application_id) { '0987654321uuid' }
  let(:client_application_attributes) do
    {
      'name' => 'TEST_POLICY_APP',
      'redirect_uri' => 'https://www.test_policy_app.com'
    }
  end

  let(:client_application_acl) do
    JSON.unparse(
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
    )
  end

  let(:user_acl) do
    JSON.unparse(
      'jsonapi' =>  { 'version' => '1.0' },
      'data' => {
        'id' => 0,
        'type' =>  'acls',
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
              'id' =>  gandalf_user_id,
              'type' => 'users'
            }
          },
          'groups' => { 'data' => [] }
        }
      },
      'included' => [
        {
          'id' => client_application_id,
          'type' => 'client_applications',
          'attributes' => client_application_attributes
        },
        {
          'id' =>  gandalf_user_id,
          'type' => 'users',
          'attributes' => {
            'platform_id' => gandalf_employee.id.to_s,
            'disabled_by_salido' => false,
            'first_name' => 'Gandalf',
            'last_name' => 'The Grey',
            'time_zone' => 'EST',
            'legally_agreed_at' => 1.year.ago,
            'legally_agreed_ip_address' => '192.168.0.1',
            'email' => 'gandalf@example.com'
          }
        }
      ]
    )
  end

  let(:gandalf_acl) { user_acl }

  let(:action) { :get }
  let(:url) { "#{ENV['GANDALF_URL']}/token/acl" }
  let(:headers) { gandalf_header }
  let(:status) { 200 }
  let(:body) { gandalf_acl }

  before do
    ENV['GANDALF_URL'] = 'https://www.gandalf.com'
    stub_request(action, url)
      .with(headers: headers)
      .to_return(status: status, body: body, headers: {})
  end
end
