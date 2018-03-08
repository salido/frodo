# frozen_string_literal: true

describe Frodo::User do
  include_context 'shared context'

  context '#frodo_user' do
    subject { described_class.instance(JSON.parse(acl)).frodo_user }

    context 'user' do
      let(:acl) { user_acl }

      it "returns a user if it's a user_acl" do
        expect(subject['type']).to eq('users')
      end

      context 'privileges' do
        let(:gandalf_privileges) { %w[foo Bar BAZ 12345::pow] }

        it 'upcases all of the privileges' do
          expect(subject.privileges).to eq(['FOO', 'BAR', 'BAZ', '12345::POW'])
        end
      end
    end

    context 'client_application' do
      let(:acl) { client_application_acl }

      it "returns a client_application if it's a client_application_acl" do
        expect(subject['type']).to eq('client_applications')
      end

      context 'privileges' do
        let(:gandalf_privileges) { %w[foo Bar BAZ 12345::pow] }

        it 'upcases all of the privileges' do
          expect(subject.privileges).to eq(['FOO', 'BAR', 'BAZ', '12345::POW'])
        end
      end
    end
  end
end
