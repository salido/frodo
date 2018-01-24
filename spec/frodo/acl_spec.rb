describe Frodo::Acl do
  include_context 'shared context'

  context '#acl' do
    subject { described_class.new(token).acl }

    context 'errors' do
      xcontext 'when the connection is refused' do # not sure how to test this
        let(:body) { Errno::ECONNREFUSED.new('boo') }

        it 'returns a BadUrlError' do
          expect { subject }.to raise_error(Frodo::Errors::BadUrlError)
        end
      end

      context "when there's a JSON parsing error" do
        let(:body) { 'stupidbody: , bleh' }

        it 'returns a JsonError' do
          expect { subject }.to raise_error(Frodo::Errors::JsonError)
        end
      end

      xcontext 'when the token is expired' do # not sure how to test this
        let(:status) { 401 }
        let(:body) { JSON.unparse('error' => 'The access token expired') }

        it 'returns a TokenExpiredError' do
          expect { subject }.to raise_error(Frodo::Errors::TokenExpiredError)
        end
      end

      context 'all other errors' do
        let(:status) { 401 }
        let(:body) { JSON.unparse('error' => 'The access token expired') }

        it 'returns an AclError' do
          expect { subject }.to raise_error(Frodo::Errors::AclError)
        end
      end

      context 'when a token is not provided' do
        let(:token) { '' }

        it 'returns a MissingTokenError' do
          expect { subject }.to raise_error(Frodo::Errors::MissingTokenError)
        end
      end
    end

    context 'dredd' do
      before { ENV['DREDD'] = '1' }
      after { ENV['DREDD'] = '0' }

      it 'does not return anything' do
        expect(subject).to eq(nil)
      end
    end

    context 'with valid params' do
      it 'returns the gandalf acl' do
        expect(subject['data']['type']).to eq('acls')
      end
    end
  end
end
