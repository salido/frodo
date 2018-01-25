describe Frodo::User do
  include_context 'shared context'

  context '#frodo_user' do
    it "returns a user if it's a user_acl" do
      expect(described_class.instance(JSON.parse(user_acl))
        .frodo_user['type']).to eq('users')
    end

    it "returns a client_application if it's a client_application_acl" do
      expect(described_class.instance(JSON.parse(client_application_acl))
        .frodo_user['type']).to eq('client_applications')
    end
  end
end
