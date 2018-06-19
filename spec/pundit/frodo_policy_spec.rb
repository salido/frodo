# frozen_string_literal: true

class FrodoPolicyTester < Frodo::Pundit::FrodoPolicy
  def owner?
    super
  end

  def has_privilege?(priv, scope = nil)
    super(priv, scope)
  end

  def salido_pos?
    super
  end

  def salido_bridge?
    super
  end
end

describe FrodoPolicyTester do
  include_context 'frodo_user'

  subject { described_class.new(frodo_user, resource) }
  let(:resource) { OpenStruct }

  describe 'when frodo_user is a user' do
    let(:frodo_user) { user }

    context '#owner' do
      it "shouldn't have an owner" do
        expect(subject.owner?).to eq(false)
      end

      context 'when user is owner' do
        let(:resource) { OpenStruct.new(resource_owner_id: resource_owner_id) }

        it 'should have an owner' do
          expect(subject.owner?).to eq(true)
        end
      end
    end

    context '#salido_pos?' do
      context 'when the client application is the POS' do
        let(:client_app) { 'SALIDO_POS' }
        it 'is true' do
          expect(subject.salido_pos?).to be true
        end
      end
      context 'when the client application is not the POS' do
        let(:client_app) { 'I_AM_BATMAN' }
        it 'is false' do
          expect(subject.salido_pos?).to be false
        end
      end
    end

    context '#salido_bridge?' do
      context 'when the client application is the BRIDGE' do
        let(:client_app) { 'SALIDO_BRIDGE' }
        it 'is true' do
          expect(subject.salido_bridge?).to be true
        end
      end
      context 'when the client application is not the BRIDGE' do
        let(:client_app) { 'I_AM_BATMAN' }
        it 'is false' do
          expect(subject.salido_bridge?).to be false
        end
      end
    end

    context '#has_privilege' do
      context 'non location scoped privileges' do
        context 'without the priv' do
          it 'will fail' do
            expect { subject.has_privilege?(:foo) }
              .to raise_error Frodo::Errors::MissingPrivilegeError, 'Missing required privilege foo'
          end
        end

        context 'when user is resource' do
          let(:gandalf_privileges) { %w[foo] }
          it 'is true' do
            expect(subject.has_privilege?(:foo)).to be true
          end
        end
      end

      context 'location scoped privileges' do
        context 'within location scope' do
          context 'without the priv' do
            it 'will fail' do
              expect { subject.has_privilege?(:foo, '12345') }
                .to raise_error Frodo::Errors::MissingPrivilegeError, 'Missing required privilege foo for 12345'
            end
          end

          context 'when user is resource' do
            let(:gandalf_privileges) { %w[12345::foo] }
            it 'is true' do
              expect(subject.has_privilege?(:foo, '12345')).to be true
            end

            context 'it is case insensitive' do
              let(:gandalf_privileges) { %w[12345::fOO] }
              it 'is true' do
                expect(subject.has_privilege?(:foo, '12345')).to be true
              end
            end
          end
        end

        context 'oustide location scope' do
          context 'without the priv' do
            let(:gandalf_privileges) { %w[bar] }
            it 'will fail' do
              expect { subject.has_privilege?(:foo, '12345') }
                .to raise_error Frodo::Errors::MissingPrivilegeError, 'Missing required privilege foo for 12345'
            end
          end

          context 'when user is resource' do
            let(:gandalf_privileges) { %w[foo] }
            it 'is true' do
              expect(subject.has_privilege?(:foo, '12345')).to be true
            end

            context 'it is case insensitive' do
              let(:gandalf_privileges) { %w[12345::foo] }
              it 'is true' do
                expect(subject.has_privilege?(:fOO, '12345')).to be true
              end
            end
          end
        end
      end
    end
  end

  describe 'when frodo_user is an client application' do
    let(:frodo_user) { client_application }

    context '#owner' do
      it "shouldn't have an owner" do
        expect(subject.owner?).to eq(false)
      end

      context 'user cannot be owner' do
        let(:resource) { OpenStruct.new(resource_owner_id: resource_owner_id) }

        it 'should not have an owner' do
          expect(subject.owner?).to eq(false)
        end
      end
    end

    context '#salido_pos?' do
      context 'when the client application is the POS' do
        let(:client_app) { 'SALIDO_POS' }
        it 'is true' do
          expect(subject.salido_pos?).to be true
        end
      end
      context 'when the client application is not the POS' do
        let(:client_app) { 'I_AM_BATMAN' }
        it 'is false' do
          expect(subject.salido_pos?).to be false
        end
      end
    end

    context '#salido_bridge?' do
      context 'when the client application is the BRIDGE' do
        let(:client_app) { 'SALIDO_BRIDGE' }
        it 'is true' do
          expect(subject.salido_bridge?).to be true
        end
      end
      context 'when the client application is not the BRIDGE' do
        let(:client_app) { 'I_AM_BATMAN' }
        it 'is false' do
          expect(subject.salido_bridge?).to be false
        end
      end
    end

    context '#has_privilege' do
      context 'without the priv' do
        it 'will fail' do
          expect { subject.has_privilege?(:foo) }
            .to raise_error Frodo::Errors::MissingPrivilegeError, 'Missing required privilege foo'
        end
      end

      context 'when user is resource' do
        let(:gandalf_privileges) { %w[foo] }
        it 'is true' do
          expect(subject.has_privilege?(:foo)).to be true
        end
      end

      context 'location scoped privileges' do
        context 'within location scope' do
          context 'without the priv' do
            it 'will fail' do
              expect { subject.has_privilege?(:foo, '12345') }
                .to raise_error Frodo::Errors::MissingPrivilegeError, 'Missing required privilege foo for 12345'
            end
          end

          context 'when user is resource' do
            let(:gandalf_privileges) { %w[12345::foo] }
            it 'is true' do
              expect(subject.has_privilege?(:foo, '12345')).to be true
            end

            context 'it is case insensitive' do
              let(:gandalf_privileges) { %w[12345::FOO] }
              it 'is true' do
                expect(subject.has_privilege?(:foo, '12345')).to be true
              end
            end
          end
        end

        context 'oustide location scope' do
          context 'without the priv' do
            let(:gandalf_privileges) { %w[bar] }
            it 'will fail' do
              expect { subject.has_privilege?(:foo, '12345') }
                .to raise_error Frodo::Errors::MissingPrivilegeError, 'Missing required privilege foo for 12345'
            end
          end

          context 'when user is resource' do
            let(:gandalf_privileges) { %w[foo] }
            it 'is true' do
              expect(subject.has_privilege?(:foo, '12345')).to be true
            end

            context 'it is case insensitive' do
              let(:gandalf_privileges) { %w[FOO] }
              it 'is true' do
                expect(subject.has_privilege?(:Foo, '12345')).to be true
              end
            end
          end
        end
      end
    end
  end
end
