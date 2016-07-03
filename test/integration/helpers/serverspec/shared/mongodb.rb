shared_examples 'profile::db::mongodb' do
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
