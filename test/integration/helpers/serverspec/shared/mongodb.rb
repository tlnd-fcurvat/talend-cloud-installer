shared_examples 'profile::mongodb' do

  it_behaves_like 'profile::defined', 'mongodb'
  it_behaves_like 'profile::common::packages'

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

  describe 'testdb collection list' do
    subject { command('mongo localhost:27017/testdb -u user1 -p pass1 --eval "printjson(db.getCollectionNames())"').stdout }
    it { should include '"dummyData"' }
  end

end
