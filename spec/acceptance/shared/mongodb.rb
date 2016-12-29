shared_examples 'profile::mongodb' do

  it_behaves_like 'profile::defined', 'mongodb'
  it_behaves_like 'profile::common::packages'

  describe service('mongod') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(27017) do
    it { should be_listening }
  end

  describe file('/var/lib/mongo') do
    it do
      should be_mounted.with(
        :type    => 'xfs',
        :options => {
          :rw         => true,
          :noatime    => true,
          :nodiratime => true,
          :noexec     => true
        }
      )
    end
  end

  describe command('/usr/bin/mongo -u admin -p mypassword ipaas --eval "printjson(db.getUser(\'admin\'));" | /usr/bin/tr -d "\t\n "') do
    its(:stdout) { should include '{"role":"userAdminAnyDatabase","db":"admin"}' }
    its(:stdout) { should include '{"role":"dbAdminAnyDatabase","db":"admin"}' }
    its(:stdout) { should include '{"role":"readWriteAnyDatabase","db":"admin"}' }
    its(:stdout) { should include '{"role":"dbOwner","db":"ipaas"}' }
  end

  describe file('/var/lock/mongo_admin_user_lock') do
    it { should be_file }
  end

  describe 'Logrotate configuration' do
    subject { file('/etc/logrotate.d/mongodb_log').content }
    it { should include '/var/log/mongodb/mongod.log' }
    it { should include 'copytruncate' }
    it { should include 'daily' }
  end

end
