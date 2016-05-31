require 'spec_helper_acceptance'

describe "role::mongodb" , :if => fact('hostname').match(/mongodb/)do
  let(:pp) do
    <<-EOS
        class { 'role::mongodb':
        }
    EOS
  end

  it_behaves_like "a idempotent resource"

  context 'should have mongodb role configured' do

    describe package('mongodb-server') do
      it { is_expected.to be_installed }
    end

    describe service('mongod') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe port(27017) do
      it { should be_listening }
    end

  end
end



