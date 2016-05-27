require 'spec_helper_acceptance'



describe "profile::mongodb" do
  let(:pp) do
    <<-EOS
        class { 'profile::db::nexus':
        }
    EOS
  end

  it_behaves_like "a idempotent resource"
end

describe 'should have nexus profile configured' do
  describe service('nexus') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(8081) do
    it { should be_listening }
  end

end

