# frozen_string_literal: true

RSpec.shared_context 'shared context' do
  let(:token) { 'Bearer testToken123' }

  let(:gandalf_header) do
    { AUTHORIZATION: token }
  end

  let(:gandalf_employee) { double('employee', id: ::BSON::ObjectId.new) }

  let(:gandalf_privileges) { %w[GONDOR ISENGUARD ITHILLIEN LOTHLORIEN MORDOR] }

  let(:gandalf_user_id) { SecureRandom.uuid }

  let(:client_application_name) { 'TESTAPP10' }

  let(:client_application_acl) do
    JSON.unparse(
      'jsonapi' => { 'version' => '1.0' },
      'data' => {
        'id' => 0,
        'type' => 'acls',
        'attributes' => {
          'client_application' => client_application_name,
          'privileges' => gandalf_privileges
        },
        'relationships' => {
          'groups' => { 'data' => [] }
        }
      },
      'included' => []
    )
  end

  let(:user_acl) do
    JSON.unparse(
      'jsonapi' =>  { 'version' => '1.0' },
      'data' => {
        'id' => 0,
        'type' =>  'acls',
        'attributes' => {
          'client_application' =>  client_application_name,
          'privileges' => gandalf_privileges
        },
        'relationships' => {
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
  let(:url) { ENV['GANDALF_ACL_URL'] }
  let(:headers) { gandalf_header }
  let(:status) { 200 }
  let(:body) { gandalf_acl }

  before do
    ENV['GANDALF_ACL_URL'] = 'https://www.gandalf.com'
    stub_request(action, url)
      .with(headers: headers)
      .to_return(status: status, body: body, headers: {})
  end
end
