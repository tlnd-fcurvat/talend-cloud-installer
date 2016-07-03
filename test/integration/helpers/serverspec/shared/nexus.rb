shared_examples 'profile::db::nexus' do
  describe service('nexus') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(8081) do
    it { should be_listening }
  end
end
