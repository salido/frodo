describe Frodo::Extension do
  context '#protect' do
    it 'sets auth as the resource on the description hash' do
      Grape::API.protect
      expect(Grape::API.route_setting(:description)).to eq(auth: { resource: :all })
    end

    it 'sets auth as the rein the description hash when it is called with a parameter' do
      Grape::API.protect(:foo)
      expect(Grape::API.route_setting(:description)).to eq(auth: { resource: :foo })
    end
  end
end
