# frozen_string_literal: true

describe Frodo::UserFinder do
  let(:body) { JSON.unparse(user) }
  let(:headers) do
    { 'AUTHORIZATION' => token }
  end
  let(:status) { 200 }
  let(:token) { 'Bearer test-token-here' }
  let(:url) { "#{ENV['GANDALF_URL']}/users/#{user_id}" }

  let(:user_id) { '6940f407-06d2-480e-a52c-002ff7b28503' }

  before do
    ENV['GANDALF_URL'] = 'https://www.gandalf.com'

    stub_request(:get, url)
      .with(headers: headers)
      .to_return(status: status, body: body, headers: {})
  end

  subject { described_class.run(token: token, user_id: user_id) }

  context 'user ok' do
    let(:user) do
      {
        'jsonapi' =>  { 'version' => '1.0' },
        'data' => {
          'id' => user_id,
          'type' =>  'users',
          'attributes' => {
            'platform_id' => 'stranger.platform_id',
            'disabled_by_salido' => 'stranger.disabled_by_salido',
            'first_name' => 'stranger.first_name',
            'last_name' => 'stranger.last_name',
            'time_zone' => 'stranger.time_zone',
            'legally_agreed_at' => 'stranger.legally_agreed_at',
            'legally_agreed_ip_address' => 'stranger.legally_agreed_ip_address',
            'email' => 'stranger.email'
          }
        },
        'included' => []
      }
    end
    it { is_expected.to be_a Frodo::User::FORMAT }
  end

  context 'user not found' do
    let(:status) { 404 }
    let(:user) do
      {
        'error' => "Couldn't find User"
      }
    end
    it 'raises' do
      expect { subject }.to raise_error Frodo::Errors::NotFoundError
    end
  end
end
