# frozen_string_literal: true

describe Frodo::Profile do
  let(:location) do
    OpenStruct.new(id: 'asdf')
  end

  let(:id) { '12345' }

  let(:token) { 'Foobarbaz' }

  let(:headers) do
    { Authorization: token }
  end

  let(:good_body_values) do
    {
      'data' => {
        'id' => 'dfb70c18-0677-4e4f-bce4-17158eba0ecf',
        'type' => 'profiles',
        'attributes' => {
          'version' => 1,
          'data' => {
            'configs' => {
              'LEVELUP_TEST' => { 'value' => '2', 'value_type' => nil },
              'SALIDO_POS_TEST' => { 'value' => '1', 'value_type' => 'int' },
              'LEVELUP_API_TOKEN' => { 'value' =>
                'db6c952e67260514f68d43e3b038ceeaa10d54f23c8d3bf106d742fd2b489d8cMerchant',
                                       'value_type' => 'Brand' },
              'LEVELUP_MERCHANT_ID' => { 'value' => '194', 'value_type' => 'Brand' },
              'SALIDO_POS_SOME CONFIG NAME' =>
                { 'value' => 'some config value', 'value_type' => 'String' }
            },
            'client_applications' => { '11' => 'SALIDO_POS', '12' => 'LEVELUP' }
          }
        },
        'expires_at' => nil,
        'scopable_type' => 'Group',
        'scopable_id' => 'c1d64eca-d1ff-4569-9b7d-f049866160f1',
        'created_at' => 'Wed, 29 Aug 2018 14:52:39 UTC +00:00',
        'updated_at' => 'Wed, 29 Aug 2018 14:52:39 UTC +00:00'
      }
    }
  end

  context '.get' do
    before do
      ENV['GANDALF_URL'] = 'https://www.gandalf.com'
      stub_request(:get, ENV['GANDALF_URL'] + '/profiles/12345?version=2')
        .to_return(status: status, body: body, headers: {})
    end

    subject { described_class.get(id: id, version: 2) }

    context 'errors' do
      context "when there's a JSON parsing error" do
        let(:status) { 200 }
        let(:body) { 'stupidbody: , bleh' }

        it 'returns a JsonError' do
          expect { subject.data }.to raise_error(Frodo::Errors::JsonError)
        end
      end

      context 'all other errors' do
        let(:status) { 401 }
        let(:body) do
          JSON.unparse(error: 'The access token expired')
        end

        it 'returns an ProfileError' do
          expect { subject.data }.to raise_error(Frodo::Errors::ProfileError)
        end
      end
    end

    context 'with valid params' do
      let(:status) { 200 }

      let(:body) do
        JSON.unparse(good_body_values)
      end

      it 'returns the gandalf profile' do
        expect(subject.data['data']['attributes']['data']['configs']['SALIDO_POS_TEST'])
          .to eq('value' => '1', 'value_type' => 'int')

        expect(subject.client_applications)
          .to eq good_body_values['data']['attributes']['data']['client_applications']
        expect(subject.configs)
          .to eq good_body_values['data']['attributes']['data']['configs']
        expect(subject.id)
          .to eq good_body_values['data']['id']
        expect(subject.version)
          .to eq good_body_values['data']['attributes']['version']
      end
    end
  end

  context '.instance' do
    before do
      ENV['GANDALF_URL'] = 'https://www.gandalf.com'
      stub_request(:get, ENV['GANDALF_URL'] + '/locations/asdf/profile')
        .with(headers: headers)
        .to_return(status: status, body: body, headers: {})
    end

    subject { described_class.instance(location: location, token: token).data }

    context 'errors' do
      context "when there's a JSON parsing error" do
        let(:status) { 200 }
        let(:body) { 'stupidbody: , bleh' }

        it 'returns a JsonError' do
          expect { subject }.to raise_error(Frodo::Errors::JsonError)
        end
      end

      context 'all other errors' do
        let(:status) { 401 }
        let(:body) do
          JSON.unparse(error: 'The access token expired')
        end

        it 'returns an ProfileError' do
          expect { subject }.to raise_error(Frodo::Errors::ProfileError)
        end
      end
    end

    context 'with valid params' do
      let(:status) { 200 }

      let(:body) { JSON.unparse(good_body_values) }

      it 'returns the gandalf profile' do
        expect(subject['data']['attributes']['data']['configs']['SALIDO_POS_TEST'])
          .to eq('value' => '1', 'value_type' => 'int')
      end
    end
  end

  describe described_class.new(gandalf_url: 'test') do
    it { is_expected.to respond_to :id }
    it { is_expected.to respond_to :version }
    it { is_expected.to respond_to :configs }
    it { is_expected.to respond_to :client_applications }
  end
end
