require 'spec_helper_acceptance'



describe "profile::mongodb" do
  let(:pp) do
    <<-EOS
        class { 'profile::db::mongodb':
        }
    EOS
  end

  it_behaves_like "a idempotent resource"
end

describe 'should have mongodb profile configured' do
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

